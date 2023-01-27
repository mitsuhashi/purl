# coding: utf-8

RedirectType.create(:symbol => 'simple', :rd_type => 'Simple redirect')
RedirectType.create(:symbol => '302', :rd_type => 'Simple redirection to a target URL (302)')
RedirectType.create(:symbol => '301', :rd_type => 'Moved permanently to a target URL (301)')
RedirectType.create(:symbol => '303', :rd_type => 'See other URLs (use for Semantic Web resources) (303)')
RedirectType.create(:symbol => '307', :rd_type => 'Temporary redirect to a target URL (307)')
RedirectType.create(:symbol => '404', :rd_type => 'Temporarily gone (404)')
RedirectType.create(:symbol => '410', :rd_type => 'Permanently gone (410)')
RedirectType.create(:symbol => 'clone', :rd_type => 'Clone an existing PURL')
RedirectType.create(:symbol => 'chain', :rd_type => 'Chain an existing PURL')
RedirectType.create(:symbol => 'partial', :rd_type => 'Partial-redirect PURL')
RedirectType.create(:symbol => 'partial-append-extension', :rd_type => 'Partial-redirect PURL with appended file extension(s)')
RedirectType.create(:symbol => 'partial-replace-extension', :rd_type => 'Partial-redirect PURL with replaced file extension(s)')
RedirectType.create(:symbol => 'partial-ignore-extension', :rd_type => 'Partial-redirect PURL with ignored file extension(s)')
