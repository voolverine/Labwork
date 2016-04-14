#include <bits/stdc++.h>

using namespace std;

class Treap 
{

public:
    int key, value;
    Treap *l, *r;

    Treap(int key, int value): key(key), value(value), l(NULL), r(NULL) {}
    Treap() {}


    static pair<Treap *, Treap *> split(Treap *t, int key) 
    {
        if (t == NULL) 
        {
            Treap *empty = NULL;
            return make_pair(empty, empty);
        } else
        if (key > t -> key) 
        {
            pair<Treap *, Treap *> res = split(t -> r, key);
            t -> r = res.first;
            return make_pair(t, res.second);
        } else 
        {
            pair<Treap *, Treap *> res = split(t -> l, key);
            t -> l = res.second;
            return make_pair(res.first, t);
        }
    }


    static Treap *merge(Treap *t1, Treap *t2) 
    {
        if (t2 == NULL) 
        {
            return t1;
        }
        if (t1 == NULL) 
        {
            return t2;
        }

        if (t1 -> value > t2 -> value) 
        {
            t1 -> r = merge(t1 -> r, t2);
            return t1;
        } else 
        {
            t2 -> l = merge(t1, t2 -> l); 
            return t2;
        }
    }

    
    static Treap *insert(Treap *t, int key, int value) 
    {
        pair<Treap *, Treap *> splitted = split(t, key); 
        
        Treap *treap = new Treap(key, value);
        splitted.first = merge(splitted.first, treap);
        splitted.first = merge(splitted.first, splitted.second);

        return splitted.first;
    }


    static Treap *find(Treap *t, int key) 
    {
        if (t == NULL) 
        {
            return NULL;
        }

        if (key == t -> key) 
        {
            return t;
        }
        
        if (key < t -> key) 
        {
            return find(t -> l, key);
        } else 
        {
            return find(t -> r, key);
        }
    }



    static Treap *removeLeftLeaf(Treap *t) 
    {
        if (t -> l == NULL) 
        {
            if (t -> r != NULL) 
            {
                return t -> r;
            } else 
            {
                return NULL;
            }
        }

        t -> l = removeLeftLeaf(t -> l);
        return t;
    }


    static Treap *remove(Treap *t, int key) 
    {
        pair<Treap *, Treap *> splitted = split(t, key);

        splitted.second = removeLeftLeaf(splitted.second);

        return merge(splitted.first, splitted.second);
    }


    static void show_treap(Treap *t, int tabs = 0) 
    {
        if (t == NULL) 
        {
            return;
        }

        for (int i = 0; i < tabs; i++) 
        {
            printf("    "); // tab == 4 :D
        }
        
        printf("key = %d value = %d\n", t -> key, t -> value);
        show_treap(t -> l, tabs + 1);
        show_treap(t -> r, tabs + 1);
    }

};


int main() 
{
    freopen("input.txt", "r", stdin);

    int n;
    scanf("%d", &n);

    Treap *t;
    for (int i = 0; i < n; i++) 
    {
        int key, value;
        scanf("%d %d", &key, &value);
        if (i == 0) 
        {
            t = new Treap(key, value);
        } else 
        {
            t = Treap :: insert(t, key, value);
        }
    }


    Treap :: show_treap(t);
   
/*  Remove example 
 *  t = Treap :: remove(t, 2);
 *  Treap :: show_treap(t);
 */

/*  Find example
 *  Treap *it = Treap :: find(t, 13);
 *  printf("Found node key = %d, value = %d\n", it -> key, it -> value);
 *  return 0;
 */
}

