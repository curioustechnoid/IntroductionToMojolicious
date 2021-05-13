package myWebSite::Model::Database;
use Mojo::Base -base;

has 'mysql';

# Subroutine to get all the testimonials
sub fetch_all_testimonials{ shift->mysql->db->query('select * from tct_mojo_testimonials order by published_on desc')->hashes->to_array }

# Subroutine to insert the new testimonial to database
sub publish_testimonial{


   my ($self, $new_testimonial, $username) = @_;
   my $sql = 'insert into tct_mojo_testimonials(published_by,testimonial) values (?,?)';


   $self->mysql->db->query($sql, $username, $new_testimonial);

}


1;


