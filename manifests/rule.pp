# Defined type for an audit rule fragment
#
#  params:
#    - content: The file source
#    - order:   Relative order of this fragment
define auditd::rule(
  $ensure   = present,
  $content  = '',
  $source  = '',
  $order    = 20,
) {

  # sudo skipping file names that contain a "."
  $dname = regsubst($name, '\.', '-', 'G')

  $manage_source = $source ? {
    ''      => undef,
    default => $source,
  }

  $manage_content = $content ? {
    ''      => undef,
    default => inline_template('<%= [@content].flatten.join("\n") + "\n" %>'),
  }


  concat::fragment{ "auditd_fragment_${name}":
    ensure  => $ensure,
    target  => $auditd::config::rules_file,
    order   => $order,
    content => $manage_content,
    source  => $manage_source,
  }
}
