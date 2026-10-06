# frozen_string_literal: true

Redmine::MenuManager.map :admin_menu do |menu|
  original_item = menu.find(:redmine_git_hosting)
  next unless original_item

  parent = original_item.parent
  position = original_item.position
  parent.remove!(original_item)
  parent.add_at(
    Redmine::MenuManager::MenuItem.new(
      :redmine_git_hosting, original_item.url,
      caption: :redmine_git_hosting, plugin: 'additionals', html: { class: 'icon' },
      icon: 'brand-git'
    ),
    position
  )
end
