import java.io.*;
import java.util.*;

class Node 
{
    private Object value;
    private Node prev;
    private Node next;

    public Node getPrev() { return prev; } 
    public void setPrev(Node value) { prev = value; }
    public void deletePrev() { prev = null; }

    public void deleteNext() { next = null; }
    public Node getNext() { return next; }
    public void setNext(Node value) { next = value; }
    public Object getValue() { return value; }
    public void setValue(Object value) { this.value = value; }

    public Node() 
    {
        value = null;
        prev = null;
        next = null;
    }

    public Node(Object value, Node prev, Node next) 
    {
        this.value = value;
        this.prev = prev;
        this.next = next;
    }

    public Node(Object value, Node next, Node prev, boolean first) 
    {
        if (first) 
        {
            this.value = value;
            this.next = next;
            this.prev = null;
        } else 
        {
            this.value = value;
            this.next = null;
            this.prev = prev; 
        }
    }
}

class List 
{
    private Node first;
    private Node last;
    private int size;

    public Node getFirst() { return first; } 
    public void setFirst(Node value) { first = value; }
    public Node getLast() { return last; }
    public void setLast(Node value) { last = value; }

    public int getSize() { return size; } 

    public void make_empty()
    {
        first = null;
        last = null;
    }


    public List() 
    {
        first = null;
        last = null;
        size = 0;
    }

    public void push_front(Object value)
    {
        Node cur = new Node(value, getFirst(), getFirst(), true);  
        if (getSize() == 0) 
        {
            setLast(cur);
        } else 
        {
            first.setPrev(cur);
        }

        setFirst(cur);

        size++;
    }

    public void push_back(Object value) 
    {
        Node cur = new Node(value, getLast(), getLast(), false);  

        if (getSize() == 0) 
        {
            setFirst(cur);
        } else 
        {
            last.setNext(cur);
        }

        setLast(cur);  

        size++;
    }

    public Object getValue(Node current)
    {
        return current.getValue();
    }


    public void Insert(Node current, Node before) 
    {
        if (before == getFirst()) 
        {
            push_front(current);
        } else 
        {
            Node temp = before.getPrev();
            temp.setNext(current);
            current.setPrev(before.getPrev());
            current.setNext(before);
            before.setPrev(current);
        }
        size++;
    }

    public Object pop_back() 
    {
        if (getSize() == 0) 
        {
            return null;
        }


        Object value = last.getValue();
        if (getSize() == 1) 
        {
            make_empty();
        } else 
        {
            setLast(last.getPrev());
            last.deleteNext();
        }
    
        size--;
        return value; 
    }

    public Object pop_front() 
    {
        if (getSize() == 0) 
        {
            return null;
        }

        Object value = first.getValue();
        if (getSize() == 1) 
        {
            make_empty();
        } else 
        {
            setFirst(first.getNext());
            first.deletePrev();
        }

        size--;
        return value;
    }

    public Object delete(Node current) 
    {
        Object value = current.getValue();

        if (current == first) 
        {
            pop_front();
        } else
        if (current == last) 
        {
            pop_back();
        } else 
        {
            Node temp = current.getPrev();
            temp.setNext(current.getNext());
            Node temp2 = current.getNext();
            temp2.setPrev(temp);
        }

        size--;
        return value;
    }

    public void clear() 
    {
        Node current = first;
        while (current != null) 
        {
            Node temp = current.getNext();
            current.deleteNext();
            current.deletePrev();
            current = temp;
            size--;
        }
        make_empty();
    }


    public boolean isEmpty() 
    {
        return size > 0 ? false : true;
    }

}

public class main
{
    public static void main(String args[]) 
    {
        List st = new List();
        for (int i = 0; i < 5; i++) 
        {
            st.push_back(i);
        }
        st.push_back("String");

        for (int i = 0; i < 5; i++) 
        {
            int a = (int)st.pop_front();
            System.out.println(a);
        }

        String s = (String)st.pop_back();
        System.out.println(s);
    }
}
