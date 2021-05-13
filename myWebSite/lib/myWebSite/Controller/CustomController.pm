package myWebSite::Controller::CustomController;
use Mojo::Base 'Mojolicious::Controller';

#
# This Subroutine will display the home page
#
sub welcome {
  my $self = shift;

  # Render template "example/welcome.html.ep" with message
  $self->render(template => 'myTemplates/homepage',msg => 'Welcome to My Personal Website!');
}

#
# This will display the login page if the user has not logged in.
# If he has, he will be redirected to home page using welcome subroutine
#
sub displayLogin {

    my $self = shift;

    # If already logged in then direct to home page, if not display login page
    if(&alreadyLoggedIn($self)){

            &welcome($self);

    }else{

       $self->render(template => "myTemplates/login", error_message =>  "");

    }

}

#
# Check if user is valid and create session cookies
#
sub validUserCheck {

    my $self = shift;

    # List of registered users
    my %validUsers = ( "JANE" => "welcome123"
                      ,"JILL" => "welcome234"
                      ,"TOM"  => "welcome345"
                      ,"RAJ"  => "test123"
                      ,"RAM"  => "digitalocean123"
                     );

    # Get the user name and password from the page
    my $user = uc $self->param('username');
    my $password = $self->param('pass');

    # First check if the user exists
    if($validUsers{$user}){

        # Validating the password of the registered user
        if($validUsers{$user} eq $password){

            # Creating session cookies
            $self->session(is_auth => 1);             # set the logged_in flag
            $self->session(username => $user);        # keep a copy of the username
            $self->session(expiration => 600);        # expire this session in 10 minutes if no activity


            # Re-direct to home page
            &welcome($self);

        }else{

            # If password is incorrect, re-direct to login page and then display appropriate message
            $self->render(template => "myTemplates/login", error_message =>  "Invalid password, please try again");
        }

    }else{

        # If user does not exist, re-direct to login page and then display appropriate message
        $self->render(template => "myTemplates/login", error_message =>  "You are not a registered user, please get the hell out of here!");

    }

}

#
# Check if user is already logged in
#
sub alreadyLoggedIn {

      my $self = shift;

      # checks if session flag (is_auth) is already set
      return 1 if $self->session('is_auth');


      # If session flag not set re-direct to login page again.
      $self->render(template => "myTemplates/login", error_message =>  "You are not logged in, please login to access this website");

      return;

}

#
# When user clicks log out, remove session
# 
sub logout {

    my $self = shift;

    # Remove session and direct to logout page
    $self->session(expires => 1);  #Kill the Session
    $self->render(template => "myTemplates/logout");

}


#
# Subroutine to get all the testimonials from the database
#
sub loadTestimonials{

    my $self = shift;
    my $all_testimonials_html;

    # Creating HTML data form the testimonials that is queried from database
    foreach my $all_testimonials (@{$self->dbhandle->fetch_all_testimonials})
    {
        $all_testimonials_html .= "
  <tr>
      <td>
          ".$all_testimonials->{testimonial}."</br></br>
          <div style='text-align: right;'><i>".$all_testimonials->{published_by}."</br>".$all_testimonials->{published_on}."</i></div>
     </td>
  </tr>";
    }
    $self->render(template => 'myTemplates/managetestimonials',msg => 'View Testimonials',alltestimonials => $all_testimonials_html);


}

#
# Subroutine to save any new testimonials entered by the user
#
sub saveTestimonial{

    my $self = shift;
    my $new_testimonial = $self->param('userReview');
    my $user = $self->session('username');

    $self->dbhandle->publish_testimonial($new_testimonial,$user);
    &loadTestimonials($self);
}



1;
