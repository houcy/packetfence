package pfappserver::Form::Config::Firewall_SSO::WatchGuard;

=head1 NAME

pfappserver::Form::Config::Firewall_SSO::WatchGuard - Web form to add a WatchGuard firewall

=head1 DESCRIPTION

Form definition to create or update a WatchGuard firewall.

=cut

use HTML::FormHandler::Moose;
extends 'pfappserver::Form::Config::Firewall_SSO';
with 'pfappserver::Base::Form::Role::Help';

use pf::config;
use pf::util;
use File::Find qw(find);

## Definition
has 'roles' => (is => 'ro', default => sub {[]});

has_field 'id' =>
  (
   type => 'Text',
   label => 'Hostname or IP Address',
   required => 1,
   messages => { required => 'Please specify the hostname or IP of the firewall' },
  );
has_field 'password' =>
  (
   type => 'ObfuscatedText',
   label => 'Secret or Key',
   required => 1,
   messages => { required => 'You must specify the password or the key' },
  );
has_field 'port' =>
  (
   type => 'PosInteger',
   label => 'Port of the service',
   default => 1813,
   tags => { after_element => \&help,
             help => 'If you use an alternative port, please specify' },
  );
has_field 'type' =>
  (
   type => 'Hidden',
  );
has_field 'categories' =>
  (
   type => 'Select',
   multiple => 1,
   label => 'Roles',
   options_method => \&options_categories,
   element_class => ['chzn-select'],
   element_attr => {'data-placeholder' => 'Click to add a role'},
   tags => { after_element => \&help,
             help => 'Nodes with the selected roles will be affected' },
  );

has_block definition =>
  (
   render_list => [ qw(id type password port categories networks cache_updates cache_timeout) ],
  );

=head2 Methods

=cut

=head2 options_categories

=cut

sub options_categories {
    my $self = shift;

    my ($status, $result) = $self->form->ctx->model('Config::Roles')->listFromDB();
    my @roles = map { $_->{name} => $_->{name} } @{$result} if ($result);
    return ('' => '', @roles);
}


=over

=back

=head1 COPYRIGHT

Copyright (C) 2005-2017 Inverse inc.

=head1 LICENSE

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
USA.

=cut

__PACKAGE__->meta->make_immutable unless $ENV{"PF_SKIP_MAKE_IMMUTABLE"};

1;
