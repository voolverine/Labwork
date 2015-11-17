using System;
using System.IO;
using System.IO.Compression;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.ComponentModel;
using System.Collections.ObjectModel;

static class random
{
    private static Random rand = new Random();

    public static int getRandomValue(int n) {
        return rand.Next(n);
    }
}

class Student : INotifyPropertyChanged
{
    string initials;
    int age;
    int group;
    double avg_mark;

    public string Initials
    {
        get { return initials; }
        set { SetProperty(ref initials, value, "Initials"); }
    }

    public int Age
    {
        get { return age; }
        set { SetProperty(ref age, value, "Age"); }
    }


    public int Group
    {
        get { return group; }
        set { SetProperty(ref group, value, "Group"); }
    }

    public double Avg_mark
    {
        get { return avg_mark; }
        set { SetProperty(ref avg_mark, value, "Avg_mark"); }
    }  

    public event PropertyChangedEventHandler PropertyChanged;

    private void SetProperty<T>(ref T field, T value, string name)
    {
        if (!EqualityComparer<T>.Default.Equals(field, value))
        {
            field = value;
            var handler = PropertyChanged;
            if (handler != null)
            {
                handler(this, new PropertyChangedEventArgs(name));
            }
        }
    }

    public Student() 
    {
        Initials = "Unknown";
        Age = 0;
        Group = 0;
        Avg_mark = 0;
    }

    public Student(string initials, int age, int group, double avg_mark) 
    {
        Initials = initials;
        Age = age;
        Group = group;
        Avg_mark = avg_mark;
    }

    public void write(StreamWriter output) 
    {
        output.WriteLine("{0}${1}${2}${3}$", Initials, Age, Group, Avg_mark);
    }

    public void read(StreamReader input) 
    {
        string line = input.ReadLine();
        string[] temp = { "", "", "", "" };

        int cur = 0;
        for (int i = 0; i < line.Length; i++)
        {
            if (line.ElementAt(i) == '$')
            {
                cur++;
                continue;
            }
            temp[cur] += line[i];
        }

        Initials = temp[0];
        Age = Int32.Parse(temp[1]);
        Group = Int32.Parse(temp[2]);
        Avg_mark = Double.Parse(temp[3]);
    }

    public void Bin_write(BinaryWriter output)
    {
        output.Write(Initials);
        output.Write(Age);
        output.Write(Group);
        output.Write(Avg_mark);
    }

    public void Bin_read(BinaryReader input)
    {
        Initials = input.ReadString();
        Age = input.ReadInt32();
        Group = input.ReadInt32();
        Avg_mark = input.ReadDouble();
    }
}


namespace Lab3
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        ObservableCollection<Student> bsuir = new ObservableCollection<Student>();

        public MainWindow()
        {
            InitializeComponent();
  
            listbox.ItemsSource = bsuir;
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            if (initials.Text.Length == 0)
            {
                MessageBox.Show("Please, write correct data!");
                return;
            }

            string new_student_initials;
            int new_student_age;
            int new_student_group;
            double new_student_avg_mark;

            try
            {
                new_student_initials = initials.Text;
                new_student_age = Int32.Parse(age.Text);
                new_student_group = Int32.Parse(group.Text);
                new_student_avg_mark = Double.Parse(avg_mark.Text);
            }
            catch (Exception) 
            {
                MessageBox.Show("Please, write correct data!");
                return;
            }

            bsuir.Add(new Student(new_student_initials,
                                   new_student_age,
                                    new_student_group,
                                     new_student_avg_mark));

            initials.Clear();
            age.Clear();
            group.Clear();
            avg_mark.Clear();   

            return;
        }

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            int index = listbox.SelectedIndex;
            if (index == -1)
            {
                MessageBox.Show("Please, select somebody first!");
                return;
            }

            bsuir.RemoveAt(index);
            return;
        }

        private void Button_Click_3(object sender, RoutedEventArgs e)
        {
            List<Student> sorted = bsuir.OrderBy(x => x.Group).ToList();

            int ptr = 0;
            while (ptr < sorted.Count())
            {
                if (!bsuir[ptr].Equals(sorted[ptr])) 
                {
                    Student temp = bsuir[ptr];
                    bsuir.RemoveAt(ptr);
                    bsuir.Insert(sorted.IndexOf(temp), temp);
                }
                else
                {
                    ptr++;
                }
            }
        }

        private void Button_Click_2(object sender, RoutedEventArgs e)
        {
            List<Student> sorted = bsuir.OrderBy(x => x.Initials).ToList();

            int ptr = 0;
            while (ptr < sorted.Count())
            {
                if (!bsuir[ptr].Equals(sorted[ptr])) 
                {
                    Student temp = bsuir[ptr];
                    bsuir.RemoveAt(ptr);
                    bsuir.Insert(sorted.IndexOf(temp), temp);
                }
                else
                {
                    ptr++;
                }
            }
        }

        private void Button_Click_4(object sender, RoutedEventArgs e)
        {
            StreamWriter output = new StreamWriter("students.txt");

            output.WriteLine(bsuir.Count);
            for (int i = 0; i < bsuir.Count; i++)
            {
                bsuir[i].write(output);
            }

            output.Dispose();
        }

        private void Button_Click_5(object sender, RoutedEventArgs e)
        {
            StreamReader input = new StreamReader("students.txt");
            int n = Int32.Parse(input.ReadLine());

            bsuir.Clear();
            for (int i = 0; i < n; i++)
            {
                Student temp = new Student();
                temp.read(input);
                bsuir.Add(temp);
            }
            input.Dispose();
        }

        private void Button_Click_6(object sender, RoutedEventArgs e)
        {
            BinaryWriter output = new BinaryWriter(File.Open("students.bin", FileMode.Create));

            output.Write(bsuir.Count);
            for (int i = 0; i < bsuir.Count; i++)
            {
                bsuir[i].Bin_write(output);
            }

            output.Dispose();
        }

        private void Button_Click_7(object sender, RoutedEventArgs e)
        {
            BinaryReader input = new BinaryReader(File.Open("students.bin", FileMode.Open));
            int n = input.ReadInt32();

            bsuir.Clear();
            for (int i = 0; i < n; i++)
            {
                Student temp = new Student();
                temp.Bin_read(input);
                bsuir.Add(temp);
            }
            input.Dispose();
        }

        private void Button_Click_8(object sender, RoutedEventArgs e)
        {
            FileStream binary_file = File.Open("students.bin", FileMode.Open);
            FileStream compressed_file = File.Open("students.cmp", FileMode.Create);
            DeflateStream compression_stream = new DeflateStream(compressed_file, CompressionMode.Compress);

            binary_file.CopyTo(compressed_file);

            compression_stream.Dispose();
            compressed_file.Dispose();
            binary_file.Dispose();
        }

        private void Button_Click_9(object sender, RoutedEventArgs e)
        {
            FileStream binary_file = File.Open("students.bin", FileMode.Create);
            FileStream compressed_file = File.Open("students.cmp", FileMode.Open);
            DeflateStream decompression_stream = new DeflateStream(compressed_file, CompressionMode.Decompress);

            compressed_file.CopyTo(binary_file);

            decompression_stream.Dispose();
            compressed_file.Dispose();
            binary_file.Dispose();
        }

        private void Button_Click_10(object sender, RoutedEventArgs e)
        {
            string person = initials.Text;
            int pos = -1;

            for (int i = 0; i < bsuir.Count; i++)
            {
                if (bsuir.ElementAt(i).Initials.Equals(person))
                {
                    pos = i;
                }
            }

            if (pos == -1)
            {
                MessageBox.Show("There is no such student in our university ;(");
            }
            else
            {
                listbox.SelectedIndex = pos;
                listbox.ScrollIntoView(listbox.Items.IndexOf(pos));
            }
        }
    }
}