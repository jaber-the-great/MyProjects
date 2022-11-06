using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace DbFinal
{
    public partial class insured_login : Form
    {
        public insured_login()
        {
            InitializeComponent();
        }
        DataClasses1DataContext dbi = new DataClasses1DataContext();

        
        
        private void label4_Click(object sender, EventArgs e)
        {

        }
        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }
        private void insured_login_Load(object sender, EventArgs e)
        {
            var q = from o in dbi.insureds join 
                    u in dbi.users on o.ID equals u.ID
                    where o.ID == Form1.IDvalue
                    select new
                    {
                       first_name = u.first_name,
                       last_name= u.last_name,
                       birthday = u.birth_day,
                       phone=u.phone,
                       kind = o.kind,
                       payment_per_period = o.payment_per_period,
                       periods = o.periods,
                       isRetired = o.isRetired,
                       start_dat = o.begin_date
                    };
            dataGridView1.DataSource = q;
        }

        private void button1_Click(object sender, EventArgs e)//doctor search
        {

        }
            
          /* 
                var q = from o in dbi.doctors
                        join p in dbi.users on o.ID equals p.ID
                        join r in dbi.addresses on p.ID equals r.ID
                        where r.city == textBox2.Text
                        select new
                        {
                            first_name = p.first_name,
                            last_name = p.first_name,
                            speciality = o.speciality,
                            phone_number = p.phone
                        };
                dataGridView1.DataSource = q;
                //dataGridView1.DataBindings();            
            }*/
           
                    
        

       
            
        private void button5_Click(object sender, EventArgs e)//pass
        {
            insured temp = dbi.insureds.FirstOrDefault(x => x.ID == Form1.IDvalue);
            temp.pass = textBox2.Text;
            dbi.SubmitChanges();
            MessageBox.Show("password changed successfully");
        } 
        

         

  
        

  

        private void button3_Click(object sender, EventArgs e)
        {

        }

        private void button3_Click_1(object sender, EventArgs e)//med prov
        {
            var q1 = from o in dbi.medical_stations
                     where o.province == textBox1.Text
                     select new
                     {
                         name = o.name,
                         phone_number = o.phone,
                         provice = o.province,
                         city = o.city,
                         street = o.street,
                         pelak = o.pelak,
                         postal_code = o.postal_code
                     };
            dataGridView1.DataSource = q1;
        }

        private void button4_Click(object sender, EventArgs e)//med name
        {
            var q = from o in dbi.medical_stations
                    where o.name == textBox1.Text
                    select new
                    {
                        name = o.name,
                        phone_number = o.phone,
                        provice = o.province,
                        city = o.city,
                        street = o.street,
                        pelak = o.pelak,
                        postal_code = o.postal_code
                    };
            dataGridView1.DataSource = q;
        }

        private void button2_Click(object sender, EventArgs e)//dr spec
        {
            var q = from o in dbi.doctors
                    join p in dbi.users on o.ID equals p.ID
                    join r in dbi.addresses on p.ID equals r.ID
                    where o.speciality == textBox1.Text
                    select new
                    {
                        first_name = p.first_name,
                        last_name = p.last_name,
                        speciality = o.speciality,
                        contrcat_rate = o.contract_rate,
                        city = r.city,
                        phone_number = p.phone
                    };
            dataGridView1.DataSource = q;
        }

        private void button1_Click_1(object sender, EventArgs e)//dr name
        {
            var q = from o in dbi.doctors
                    join p in dbi.users on o.ID equals p.ID
                    join r in dbi.addresses on p.ID equals r.ID
                    where p.last_name == textBox1.Text
                    select new
                    {
                        first_name = p.first_name,
                        last_name = p.last_name,
                        speciality = o.speciality,
                        contrcat_rate=o.contract_rate,
                        city = r.city,
                        phone_number = p.phone
                    };
            dataGridView1.DataSource = q;
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void button6_Click(object sender, EventArgs e)//dr city
        {
            var q = from o in dbi.doctors
                    join p in dbi.users on o.ID equals p.ID
                    join r in dbi.addresses on p.ID equals r.ID
                    where r.city == textBox1.Text
                    select new
                    {
                        first_name = p.first_name,
                        last_name = p.last_name,
                        speciality = o.speciality,
                        contrcat_rate = o.contract_rate,
                        city = r.city,
                        phone_number = p.phone
                    };
            dataGridView1.DataSource = q;
        }

        private void button7_Click(object sender, EventArgs e)
        {
            Form1 a = new Form1();
            a.Show();
            Hide();
        }

      
      

    }
}
