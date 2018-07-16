package Finance::Robinhood::Watchlist::Item;
use Moo;
use Time::Moment;
has [qw[url]] => ( is => 'ro' );
has ['created_at'] => (
    is     => 'ro',
    coerce => sub {
        Time::Moment->from_string( $_[0] );
    }
);
has '_instrument_url' => ( is => 'ro', init_arg => 'instrument' );
has 'instrument' => (
    is       => 'ro',
    lazy     => 1,
    init_arg => undef,
    builder  => sub {
        my ( $status, $data )
            = Finance::Robinhood::Utils::Client->instance->get( $_[0]->_instrument_url );
        $status == 200 ? Finance::Robinhood::Equity::Instrument->new($data) : $data;
    }
);
has '_watchlist_url' => ( is => 'ro', init_arg => 'watchlist' );
has 'watchlist' => (
    is       => 'ro',
    lazy     => 1,
    init_arg => undef,
    builder  => sub {
        my ( $status, $data )
            = Finance::Robinhood::Utils::Client->instance->get( $_[0]->_watchlist_url );
        $status == 200 ? Finance::Robinhood::Watchlist->new($data) : $data;
    }
);
1;