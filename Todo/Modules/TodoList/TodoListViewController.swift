//
//  TodoListViewController.swift
//  Todo
//
//  Created by Aleksandr on 15.02.2026.
//

import UIKit

protocol ITodoListView: AnyObject {}

final class TodoListViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Задачи"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .todoText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let searchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .todoSearchBackground
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let searchIconImageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: config)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .todoText.withAlphaComponent(0.5)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let searchTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Search"
        field.font = .systemFont(ofSize: 17)
        field.textColor = .todoText
        field.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: UIColor.todoText.withAlphaComponent(0.5)]
        )
        field.backgroundColor = .clear
        field.borderStyle = .none
        field.returnKeyType = .search
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private let searchMicButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular)
        let image = UIImage(systemName: "mic.fill", withConfiguration: config)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .todoText.withAlphaComponent(0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    private let footerDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .todoStroke
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let footerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let tasksCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .todoText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let addButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .todoAccent
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let footerBackgroundView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var tasks: [TodoItemDisplay] = []

    var presenter: ITodoListPresenter

    init(presenter: ITodoListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: - Setup

private extension TodoListViewController {
    func setupUI() {
        view.backgroundColor = .todoBackground

        view.addSubview(titleLabel)
        view.addSubview(searchContainerView)
        searchContainerView.addSubview(searchIconImageView)
        searchContainerView.addSubview(searchTextField)
        searchContainerView.addSubview(searchMicButton)
        view.addSubview(tableView)
        view.addSubview(footerBackgroundView)
        view.addSubview(footerDivider)
        view.addSubview(footerStackView)

        footerStackView.addArrangedSubview(createSpacerView(width: 68))
        footerStackView.addArrangedSubview(createTasksCountView())
        footerStackView.addArrangedSubview(addButton)

        setupConstraints()
        setupTableView()
        loadMockData()
        presenter.viewDidLoad()
    }

    func createSpacerView(width: CGFloat) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        return view
    }

    func createTasksCountView() -> UIView {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 4
        container.alignment = .center
        container.addArrangedSubview(tasksCountLabel)
        return container
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            searchContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            searchContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchContainerView.heightAnchor.constraint(equalToConstant: 36),

            searchIconImageView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 12),
            searchIconImageView.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            searchIconImageView.widthAnchor.constraint(equalToConstant: 20),
            searchIconImageView.heightAnchor.constraint(equalToConstant: 20),

            searchTextField.leadingAnchor.constraint(equalTo: searchIconImageView.trailingAnchor, constant: 8),
            searchTextField.trailingAnchor.constraint(equalTo: searchMicButton.leadingAnchor, constant: -8),
            searchTextField.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),

            searchMicButton.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -8),
            searchMicButton.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            searchMicButton.widthAnchor.constraint(equalToConstant: 36),
            searchMicButton.heightAnchor.constraint(equalToConstant: 36),

            tableView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerBackgroundView.topAnchor),

            footerBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerBackgroundView.heightAnchor.constraint(equalToConstant: 84),

            footerDivider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerDivider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerDivider.topAnchor.constraint(equalTo: footerBackgroundView.topAnchor),
            footerDivider.heightAnchor.constraint(equalToConstant: 0.5),

            footerStackView.topAnchor.constraint(equalTo: footerDivider.bottomAnchor, constant: 5),
            footerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            footerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            footerStackView.heightAnchor.constraint(equalToConstant: 44),

            addButton.widthAnchor.constraint(equalToConstant: 68),
            addButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoListCell.self, forCellReuseIdentifier: TodoListCell.reuseId)
    }

    func loadMockData() {
        tasks = [
            TodoItemDisplay(
                title: "Почитать книгу",
                description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.",
                date: "09/10/24",
                isCompleted: true
            ),
            TodoItemDisplay(
                title: "Уборка в квартире",
                description: "Провести генеральную уборку в квартире",
                date: "02/10/24",
                isCompleted: false
            ),
            TodoItemDisplay(
                title: "Заняться спортом",
                description: "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!",
                date: "02/10/24",
                isCompleted: false
            ),
            TodoItemDisplay(
                title: "Работа над проектом",
                description: "Выделить время для работы над проектом на работе. Сфокусироваться на выполнении важных задач",
                date: "09/10/24",
                isCompleted: true
            ),
            TodoItemDisplay(
                title: "Вечерний отдых",
                description: "Найти время для расслабления перед сном: посмотреть фильм или послушать музыку",
                date: "02/10/24",
                isCompleted: false
            ),
            TodoItemDisplay(
                title: "Зарядка утром",
                description: nil,
                date: "12/10/24",
                isCompleted: false
            ),
            TodoItemDisplay(
                title: "Испанский",
                description: "Провести 30 минут за изучением испанского языка с помощью приложения",
                date: "02/10/24",
                isCompleted: false
            )
        ]
        tasksCountLabel.text = "\(tasks.count) Задач"
        tableView.reloadData()
    }
}

// MARK: - ITodoListView

extension TodoListViewController: ITodoListView {}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension TodoListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoListCell.reuseId, for: indexPath) as? TodoListCell else {
            return UITableViewCell()
        }
        cell.configure(with: tasks[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        72
    }
}
