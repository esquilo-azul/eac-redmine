# frozen_string_literal: true

namespace :avm do # rubocop:disable Metrics/BlockLength
  namespace :issue do # rubocop:disable Metrics/BlockLength
    desc 'Verifica auto-indefinição de uma tarefa'
    task :undefine, [:issue_id] => :environment do |_t, args|
      RedmineAvm::Issue::Undefine.new(Issue.find(args.issue_id)).run
    end

    desc 'Verifica auto-indefinição de todas as tarefas indefinidas'
    task undefine_all: :environment do |_t, _args|
      Issue.where.not(status: RedmineAvm::Settings.issue_status_undefined).each do |i| # rubocop:disable Rails/FindEach
        RedmineAvm::Issue::Undefine.new(i).run
      end
    end

    desc 'Verifica auto-desbloqueio de uma tarefa'
    task unblock: :environment do |_t, _args|
      Issue.where(status: RedmineAvm::Settings.issue_status_blocked).each do |i| # rubocop:disable Rails/FindEach
        RedmineAvm::Issue::Unblock.new(i).run
      end
    end

    desc 'Verifica auto-desbloqueio de todas as tarefas'
    task unblock_all: :environment do |_t, _args|
      Issue.where(status: RedmineAvm::Settings.issue_status_blocked).each do |i| # rubocop:disable Rails/FindEach
        RedmineAvm::Issue::Unblock.new(i).run
      end
    end

    desc 'Verifica auto-atribuição de todas as tarefas'
    task assign_all: :environment do |_t, _args|
      Issue.all.each do |i| # rubocop:disable Rails/FindEach
        RedmineAvm::Issue::Assign.new(i).run
      end
    end

    desc 'Verifica a seção de dependências de todas as tarefas'
    task dependencies_section_check_all: :environment do |_t, _args|
      Issue.where(closed_on: nil)
        .where.not(status: RedmineAvm::Settings.issue_status_undefined).each do |i| # rubocop:disable Rails/FindEach
        RedmineAvm::Issue::DependenciesSectionCheck.new(i).run
      end
    end

    desc 'Verifica a ausência de motivação em todas as tarefas'
    task motivation_check_all: :environment do |_t, _args|
      Issue.where(closed_on: nil)
        .where.not(status: RedmineAvm::Settings.issue_status_undefined).each do |i| # rubocop:disable Rails/FindEach
        RedmineAvm::Issue::MotivationCheck.new(i).run
      end
    end
  end
end
