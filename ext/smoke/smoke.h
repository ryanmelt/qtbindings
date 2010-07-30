#ifndef SMOKE_H
#define SMOKE_H

#include <cstddef>
#include <cstring>
#include <string>
#include <map>

/*
   Copyright (C) 2002, Ashley Winters <qaqortog@nwlink.com>
   Copyright (C) 2007, Arno Rehn <arno@arnorehn.de>

    BSD License

    Redistribution and use in source and binary forms, with or
      without modification, are permitted provided that the following
      conditions are met:

    Redistributions of source code must retain the above
      copyright notice, this list of conditions and the following disclaimer.

    Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials
      provided with the distribution.>

    THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY
    EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
    THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
    PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR
    BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
    EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
    TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
    IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
    THE POSSIBILITY OF SUCH DAMAGE.
*/

#ifdef WIN32
  // Define this when building a smoke lib that doesn't have any parents - else Smoke::classMap is not exported.
  #ifdef BASE_SMOKE_BUILDING
    #define BASE_SMOKE_EXPORT __declspec(dllexport)
  #else
    #define BASE_SMOKE_EXPORT __declspec(dllimport)
  #endif
  // Define this when building a smoke lib.
  #ifdef SMOKE_BUILDING
    #define SMOKE_EXPORT __declspec(dllexport)
  #else
    #define SMOKE_EXPORT __declspec(dllimport)
  #endif
  #define SMOKE_IMPORT __declspec(dllimport)
#else
  #ifdef GCC_VISIBILITY
    #define SMOKE_EXPORT __attribute__ ((visibility("default")))
    #define BASE_SMOKE_EXPORT __attribute__ ((visibility("default")))
  #else
    #define SMOKE_EXPORT
    #define BASE_SMOKE_EXPORT
  #endif
  #define SMOKE_IMPORT
#endif

class SmokeBinding;

class BASE_SMOKE_EXPORT Smoke {
private:
    const char *module_name;

public:
    union StackItem; // defined below
    /**
     * A stack is an array of arguments, passed to a method when calling it.
     */
    typedef StackItem* Stack;

    enum EnumOperation {
	EnumNew,
	EnumDelete,
	EnumFromLong,
	EnumToLong
    };

    typedef short Index;
    typedef void (*ClassFn)(Index method, void* obj, Stack args);
    typedef void* (*CastFn)(void* obj, Index from, Index to);
    typedef void (*EnumFn)(EnumOperation, Index, void*&, long&);

    /**
     * Describe one index in a given module.
     */
    struct ModuleIndex {
        Smoke* smoke;
        Index index;
        ModuleIndex() : smoke(0), index(0) {}
        ModuleIndex(Smoke * s, Index i) : smoke(s), index(i) {}
        
        inline bool operator==(const Smoke::ModuleIndex& other) const {
            return index == other.index && smoke == other.smoke;
        }
        
        inline bool operator!=(const Smoke::ModuleIndex& other) const {
            return index != other.index || smoke != other.smoke;
        }
    };
    /**
     * A ModuleIndex with both fields set to 0.
     */
    static ModuleIndex NullModuleIndex; 
    
    typedef std::map<std::string, ModuleIndex> ClassMap;
    static ClassMap classMap;

    enum ClassFlags {
        cf_constructor = 0x01,  // has a constructor
        cf_deepcopy = 0x02,     // has copy constructor
        cf_virtual = 0x04,      // has virtual destructor
        cf_namespace = 0x08,    // is a namespace
        cf_undefined = 0x10     // defined elsewhere
    };
    /**
     * Describe one class.
     */
    struct Class {
	const char *className;	// Name of the class
	bool external;		// Whether the class is in another module
	Index parents;		// Index into inheritanceList
	ClassFn classFn;	// Calls any method in the class
	EnumFn enumFn;		// Handles enum pointers
        unsigned short flags;   // ClassFlags
        unsigned int size;
    };

    enum MethodFlags {
        mf_static = 0x01,
        mf_const = 0x02,
        mf_copyctor = 0x04,  // Copy constructor
        mf_internal = 0x08,   // For internal use only
        mf_enum = 0x10,   // An enum value
        mf_ctor = 0x20,
        mf_dtor = 0x40,
        mf_protected = 0x80,
        mf_attribute = 0x100,   // accessor method for a field
        mf_property = 0x200,    // accessor method of a property
        mf_virtual = 0x400,
        mf_purevirtual = 0x800,
        mf_signal = 0x1000, // method is a signal
        mf_slot = 0x2000,   // method is a slot
        mf_explicit = 0x4000    // method is an 'explicit' constructor
    };
    /**
     * Describe one method of one class.
     */
    struct Method {
	Index classId;		// Index into classes
	Index name;		// Index into methodNames; real name
	Index args;		// Index into argumentList
	unsigned char numArgs;	// Number of arguments
	unsigned short flags;	// MethodFlags (const/static/etc...)
	Index ret;		// Index into types for the return type
	Index method;		// Passed to Class.classFn, to call method
    };

    /**
     * One MethodMap entry maps the munged method prototype
     * to the Method entry.
     *
     * The munging works this way:
     * $ is a plain scalar
     * # is an object
     * ? is a non-scalar (reference to array or hash, undef)
     *
     * e.g. QApplication(int &, char **) becomes QApplication$?
     */
    struct MethodMap {
	Index classId;		// Index into classes
	Index name;		// Index into methodNames; munged name
	Index method;		// Index into methods
    };

    enum TypeFlags {
        // The first 4 bits indicate the TypeId value, i.e. which field
        // of the StackItem union is used.
        tf_elem = 0x0F,

	// Always only one of the next three flags should be set
	tf_stack = 0x10, 	// Stored on the stack, 'type'
	tf_ptr = 0x20,   	// Pointer, 'type*'
	tf_ref = 0x30,   	// Reference, 'type&'
	// Can | whatever ones of these apply
	tf_const = 0x40		// const argument
    };
    /**
     * One Type entry is one argument type needed by a method.
     * Type entries are shared, there is only one entry for "int" etc.
     */
    struct Type {
	const char *name;	// Stringified type name
	Index classId;		// Index into classes. -1 for none
        unsigned short flags;   // TypeFlags
    };

    // We could just pass everything around using void* (pass-by-reference)
    // I don't want to, though. -aw
    union StackItem {
	void* s_voidp;
	bool s_bool;
	signed char s_char;
	unsigned char s_uchar;
	short s_short;
	unsigned short s_ushort;
	int s_int;
	unsigned int s_uint;
	long s_long;
	unsigned long s_ulong;
	float s_float;
	double s_double;
        long s_enum;
        void* s_class;
    };
    enum TypeId {
	t_voidp,
	t_bool,
	t_char,
	t_uchar,
	t_short,
	t_ushort,
	t_int,
	t_uint,
	t_long,
	t_ulong,
	t_float,
	t_double,
        t_enum,
        t_class,
	t_last		// number of pre-defined types
    };

    // Passed to constructor
    /**
     * The classes array defines every class for this module
     */
    Class *classes;
    Index numClasses;

    /**
     * The methods array defines every method in every class for this module
     */
    Method *methods;
    Index numMethods;

    /**
     * methodMaps maps the munged method prototypes
     * to the methods entries.
     */
    MethodMap *methodMaps;
    Index numMethodMaps;

    /**
     * Array of method names, for Method.name and MethodMap.name
     */
    const char **methodNames;
    Index numMethodNames;

    /**
     * List of all types needed by the methods (arguments and return values)
     */
    Type *types;
    Index numTypes;

    /**
     * Groups of Indexes (0 separated) used as super class lists.
     * For classes with super classes: Class.parents = index into this array.
     */
    Index *inheritanceList;
    /**
     * Groups of type IDs (0 separated), describing the types of argument for a method.
     * Method.args = index into this array.
     */
    Index *argumentList;
    /**
     * Groups of method prototypes with the same number of arguments, but different types.
     * Used to resolve overloading.
     */
    Index *ambiguousMethodList;
    /**
     * Function used for casting from/to the classes defined by this module.
     */
    CastFn castFn;

    /**
     * Constructor
     */
    Smoke(const char *_moduleName,
	  Class *_classes, Index _numClasses,
	  Method *_methods, Index _numMethods,
	  MethodMap *_methodMaps, Index _numMethodMaps,
	  const char **_methodNames, Index _numMethodNames,
	  Type *_types, Index _numTypes,
	  Index *_inheritanceList,
	  Index *_argumentList,
	  Index *_ambiguousMethodList,
	  CastFn _castFn) :
		module_name(_moduleName),
		classes(_classes), numClasses(_numClasses),
		methods(_methods), numMethods(_numMethods),
		methodMaps(_methodMaps), numMethodMaps(_numMethodMaps),
		methodNames(_methodNames), numMethodNames(_numMethodNames),
		types(_types), numTypes(_numTypes),
		inheritanceList(_inheritanceList),
		argumentList(_argumentList),
		ambiguousMethodList(_ambiguousMethodList),
		castFn(_castFn)
        {
            for (Index i = 1; i <= numClasses; ++i) {
                if (!classes[i].external) {
                    classMap[className(i)] = ModuleIndex(this, i);
                }
            }
        }

    /**
     * Returns the name of the module (e.g. "qt" or "kde")
     */
    inline const char *moduleName() {
	return module_name;
    }

    inline void *cast(void *ptr, const ModuleIndex& from, const ModuleIndex& to) {
        if (castFn == 0) {
            return ptr;
        }
        
        if (from.smoke == to.smoke) {
            return (*castFn)(ptr, from.index, to.index);
        }
        
        const Smoke::Class &klass = to.smoke->classes[to.index];
        return (*castFn)(ptr, from.index, idClass(klass.className, true).index);
    }
    
    inline void *cast(void *ptr, Index from, Index to) {
    if(!castFn) return ptr;
    return (*castFn)(ptr, from, to);
    }

    // return classname directly
    inline const char *className(Index classId) {
	return classes[classId].className;
    }

    inline int leg(Index a, Index b) {  // ala Perl's <=>
	if(a == b) return 0;
	return (a > b) ? 1 : -1;
    }

    inline Index idType(const char *t) {
        Index imax = numTypes;
        Index imin = 1;
        Index icur = -1;
        int icmp = -1;

        while (imax >= imin) {
            icur = (imin + imax) / 2;
            icmp = strcmp(types[icur].name, t);
            if (icmp == 0) {
                return icur;
            }

            if (icmp > 0) {
                imax = icur - 1;
            } else {
                imin = icur + 1;
            }
        }

        return 0;
    }

    inline ModuleIndex idClass(const char *c, bool external = false) {
        Index imax = numClasses;
        Index imin = 1;
        Index icur = -1;
        int icmp = -1;

        while (imax >= imin) {
            icur = (imin + imax) / 2;
            icmp = strcmp(classes[icur].className, c);
            if (icmp == 0) {
                if (classes[icur].external && !external) {
                    return NullModuleIndex;
                } else {
                    return ModuleIndex(this, icur);
                }
            }

            if (icmp > 0) {
                imax = icur - 1;
            } else {
                imin = icur + 1;
            }
        }

        return NullModuleIndex;
    }

    static inline ModuleIndex findClass(const char *c) {
        ClassMap::iterator i = classMap.find(c);
        if (i == classMap.end()) {
            return NullModuleIndex;
        } else {
            return i->second;
        }
    }

    inline ModuleIndex idMethodName(const char *m) {
        Index imax = numMethodNames;
        Index imin = 1;
        Index icur = -1;
        int icmp = -1;

        while (imax >= imin) {
            icur = (imin + imax) / 2;
            icmp = strcmp(methodNames[icur], m);
            if (icmp == 0) {
                return ModuleIndex(this, icur);
            }

            if (icmp > 0) {
                imax = icur - 1;
            } else {
                imin = icur + 1;
            }
        }

        return NullModuleIndex;
    }

    inline ModuleIndex findMethodName(const char *c, const char *m) {
	ModuleIndex mni = idMethodName(m);
	if (mni.index) return mni;

	ModuleIndex cmi = findClass(c);
	if (cmi.smoke && cmi.smoke != this) {
	    return cmi.smoke->findMethodName(c, m);
	} else if (cmi.smoke == this) {
	    if (!classes[cmi.index].parents) return NullModuleIndex;
	    for (Index p = classes[cmi.index].parents; inheritanceList[p]; p++) {
		Index ci = inheritanceList[p];
		const char* cName = className(ci);
		ModuleIndex mi = classMap[cName].smoke->findMethodName(cName, m);
		if (mi.index) return mi;
	    }
	}
	return NullModuleIndex;
    }

    inline ModuleIndex idMethod(Index c, Index name) {
        Index imax = numMethodMaps;
        Index imin = 1;
        Index icur = -1;
        int icmp = -1;

        while (imax >= imin) {
            icur = (imin + imax) / 2;
            icmp = leg(methodMaps[icur].classId, c);
            if (icmp == 0) {
                icmp = leg(methodMaps[icur].name, name);
                if (icmp == 0) {
                    return ModuleIndex(this, icur);
                }
            }

            if (icmp > 0) {
                imax = icur - 1;
            } else {
                imin = icur + 1;
            }
        }

        return NullModuleIndex;
    }

    inline ModuleIndex findMethod(ModuleIndex c, ModuleIndex name) {
        if (!c.index || !name.index) {
            return NullModuleIndex;
        } else if (name.smoke == this && c.smoke == this) {
            ModuleIndex mi = idMethod(c.index, name.index);
            if (mi.index) return mi;
        } else if (c.smoke != this) {
            return c.smoke->findMethod(c, name);
        }

        for (Index *i = inheritanceList + classes[c.index].parents; *i; ++i) {
            const char *cName = className(*i);
            ModuleIndex ci = findClass(cName);
            if (!ci.smoke)
                return NullModuleIndex;
            ModuleIndex ni = ci.smoke->findMethodName(cName, name.smoke->methodNames[name.index]);
            ModuleIndex mi = ci.smoke->findMethod(ci, ni);
            if (mi.index) return mi;
        }
        return NullModuleIndex;
    }

    inline ModuleIndex findMethod(const char *c, const char *name) {
        ModuleIndex idc = idClass(c);
        if (!idc.smoke) idc = findClass(c);
        if (!idc.smoke || !idc.index) return NullModuleIndex;
        ModuleIndex idname = idc.smoke->findMethodName(c, name);
        return idc.smoke->findMethod(idc, idname);
    }

    static inline bool isDerivedFrom(const ModuleIndex& classId, const ModuleIndex& baseClassId) {
        return isDerivedFrom(classId.smoke, classId.index, baseClassId.smoke, baseClassId.index);
    }
    
    static inline bool isDerivedFrom(Smoke *smoke, Index classId, Smoke *baseSmoke, Index baseId) {
	if (!classId || !baseId || !smoke || !baseSmoke)
	    return false;
	if (smoke == baseSmoke && classId == baseId)
	    return true;
	
	for(Index p = smoke->classes[classId].parents; smoke->inheritanceList[p]; p++) {
	    Class& cur = smoke->classes[smoke->inheritanceList[p]];
	    if (cur.external) {
		ModuleIndex mi = findClass(cur.className);
		if (isDerivedFrom(mi.smoke, mi.index, baseSmoke, baseId))
		    return true;
	    }
	    if (isDerivedFrom(smoke, smoke->inheritanceList[p], baseSmoke, baseId))
		return true;
	}
	return false;
    }

    static inline bool isDerivedFrom(const char *className, const char *baseClassName) {
    ModuleIndex classId = findClass(className);
    ModuleIndex baseId = findClass(baseClassName);
    return isDerivedFrom(classId.smoke, classId.index, baseId.smoke, baseId.index);
    }
};

class SmokeBinding {
protected:
    Smoke *smoke;
public:
    SmokeBinding(Smoke *s) : smoke(s) {}
    virtual void deleted(Smoke::Index classId, void *obj) = 0;
    virtual bool callMethod(Smoke::Index method, void *obj, Smoke::Stack args, bool isAbstract = false) = 0;
    virtual char* className(Smoke::Index classId) = 0;
    virtual ~SmokeBinding() {}
};

#endif
