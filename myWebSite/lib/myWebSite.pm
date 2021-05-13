package myWebSite;
use Mojo::Base 'Mojolicious';
use Mojo::mysql;
use myWebSite::Model::Database;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Load configuration from hash returned by config file
  my $config = $self->plugin('Config');

  # Configure the application
  $self->secrets($config->{secrets});

  # Database handler
  $self->helper(mysql => sub { state $mysql = Mojo::mysql->new(shift->config('mysql')) });
  $self->helper(dbhandle => sub { state $testdb = myWebSite::Model::Database->new(mysql => shift->mysql) });


  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('CustomController#displayLogin');
  $r->post('/login')->to('CustomController#validUserCheck');
  $r->any('/logout')->to('CustomController#logout');

  my $authorized = $r->under('/')->to('CustomController#alreadyLoggedIn');
  $authorized->get('/testimonials')->to('CustomController#loadTestimonials');
  $authorized->post('/testimonials')->to('CustomController#saveTestimonial');
}

1;
