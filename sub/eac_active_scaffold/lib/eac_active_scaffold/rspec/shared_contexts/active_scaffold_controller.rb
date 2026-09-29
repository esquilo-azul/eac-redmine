# frozen_string_literal: true

RSpec.shared_context 'active_scaffold_controller' do |options| # rubocop:disable Metrics/BlockLength
  director = EacActiveScaffold::Rspec::ControllerDirector.new(self, options)

  before do
    visit director.index_path
  end

  it 'show index page' do
    expect(page).to have_content director.page_title
  end

  next unless director.create?

  context 'when record is created' do # rubocop:disable Metrics/BlockLength
    let(:before_create_count) { director.model_class.count }
    let(:created_record) { director.model_class.first }
    let(:record_href) { %r{/#{Regexp.quote(created_record.id.to_s)}} }
    let(:edit_link_args) { [I18n.t('active_scaffold.edit'), { href: record_href }] }
    let(:remove_link_args) { [I18n.t('active_scaffold.delete'), { href: record_href }] }
    let(:show_link_args) { [I18n.t('active_scaffold.show'), { href: record_href }] }

    before do
      before_create_count
      click_on I18n.t('active_scaffold.create_new')
      director.attributes_set(self, director.valid_create_data)
      click_on I18n.t('active_scaffold.create')
    end

    it 'increments record count' do
      expect(director.model_class.count).to eq(before_create_count + 1)
    end

    it 'have a edit link for record' do
      options = edit_link_args.extract_options!
      expect(page).to have_link(*edit_link_args, **options)
    end

    it 'have a remove link for record' do
      options = remove_link_args.extract_options!
      expect(page).to have_link(*remove_link_args, **options)
    end

    it 'have a show link for record' do
      options = show_link_args.extract_options!
      expect(page).to have_link(*show_link_args, **options)
    end

    context 'when record is updated' do
      let(:before_update_count) { director.model_class.count }

      before do
        before_update_count
        options = edit_link_args.extract_options!
        click_link(*edit_link_args, **options)
        director.attributes_set(self, director.valid_update_data)
        click_on I18n.t('active_scaffold.update')
      end

      it 'unchanges record count' do
        expect(director.model_class.count).to eq(before_update_count)
      end
    end

    context 'when record is destroyed' do
      let(:before_destroy_count) { director.model_class.count }

      before do
        before_destroy_count
        options = remove_link_args.extract_options!
        click_link(*remove_link_args, **options)
      end

      it 'decrements record count' do
        expect(director.model_class.count).to eq(before_destroy_count - 1)
      end
    end
  end
end
