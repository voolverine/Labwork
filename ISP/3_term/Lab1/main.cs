using System;
using System.Collections;
using System.Collections.Generic;


class Person : IEquatable<Person>
{
    private String initials;

    public string Initials 
    {
        get {return initials;}
        set {initials = value;}
    }


    public Person() {} public Person(String initials) {
        Initials = initials;
    }


    public bool Equals(Person other) 
    {
        return (Initials == other.initials);
    }

    public override bool Equals(object obj) 
    {
        return base.Equals(obj);
    }
    
    public override int GetHashCode() 
    {
        return base.GetHashCode();
    }
}

/*
 * Some shit with Children Enumerator
 */


class ChildrenEnumerator: IEnumerator
{
    private nodeT> collection;
    private int currentIndex = -1;

    public ChildrenEnumerator(T collection) 
    {
        this.collection = collection;
    }

    public node Current
    {
        get {return collection[currentIndex];}
    }


}



class node<T>: ICollection<T> 
{
    private T value; 
    private List<node<T> > children;    
    // not read-only
    private bool isRO = false;

    /*
     * Implementation IEnurable interface
     */

    public IEnumerator<T> GetEnumerator() 
    {
        return new ChildrenEnumerator(this);
    }

    IEnumerator IEquatable.GetEnumerator() 
    {
        return new ChildrenEnumerator(this);
    }


    /*
     * Implementation ICollection interface
     */

    int Count {
        get {return children.Count;}
    }

    bool Contains (T item) 
    {
        foreach (T item2 in children) 
        {
            if (item2.Equals(item)) 
            {
                return true;
            }
        }
    
        return false;
    }
    
    void CopyTo(T[] array, int arrayIndex) 
    {
        for (int i = 0; i < children.Count; i++) 
        {
            array[i] = children[i];
        }
    }

    bool IsReadOnly
    {
        get {return isRO;}
    }

    void Add(T item) 
    {
        if (!Contains(item)) 
        {
            children.Add(item);
        } else 
        {
            Console.WriteLine("Such item is already exists in this node! Please, try again later ;(");
        }
    }

    bool Remove(T item) 
    {
        if (!Contains(item)) 
        {
            Console.WriteLine("Some shit happened, please try again latter ;(");
        } else 
        {
            for (int i = 0; i < children.Count; i++) 
            {
                if (item.Equals(children[i])) 
                {
                    children.RemoveAt(i);
                    Console.WriteLine("Successfully deleted");
                    return true;
                }
            }
        }

        return false;
    }

    void Clear() 
    {
        children.Clear();
    }
}


class tree<T> : ICollection<T>
{
    private T root = NULL;
}
