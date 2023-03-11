#pragma once

#include <any>
#include <memory>
#include <string>
#include <vector>

namespace go::ast {

class PackageClause;
class ImportDecl;
class FunctionDecl;
// class MethodDecl;
class Declaration;
class Visitor;

class Node {
public:
    virtual ~Node() = default;
    virtual void accept(Visitor &visitor) = 0;
};

class Program final {
private:
    std::vector<std::unique_ptr<Node>> nodes_;
    PackageClause *package_clause_ = nullptr;
    ImportDecl *import_decl_ = nullptr;
    FunctionDecl *function_decl_ = nullptr;
    // MethodDecl *method_decl_ = nullptr;
    Declaration *declaration_ = nullptr;

public:
    template <class T, class... Args> T *create_node(Args &&...args) {
        static_assert(std::is_base_of_v<Node, T>);
        nodes_.emplace_back(std::make_unique<T>(std::forward<Args>(args)...));
        return dynamic_cast<T *>(nodes_.back().get());
    }
    /* setters */
    void set_package_clause(PackageClause *package_clause) {
        package_clause_ = package_clause;
    }
    void set_import_decl(ImportDecl *import_decl) {
        import_decl_ = import_decl;
    }
    void set_function_decl(FunctionDecl *function_decl) {
        function_decl_ = function_decl;
    }
    void set_declaration(Declaration *declaration) {
        declaration_ = declaration;
    }
    /* getters */
    PackageClause *package_clause() { return package_clause_; }
    ImportDecl *import_decl() { return import_decl_; }
    FunctionDecl *function_decl() { return function_decl_; }
    Declaration *declaration() { return declaration_; }
};

class PackageName final : public Node {
private:
    std::string text_;

public:
    explicit PackageName(std::string text) : text_(std::move(text)) {}
    const std::string &text() const { return text_; }
    void accept(Visitor &visitor) override;
};

class PackageClause final : public Node {
private:
    PackageName *package_name_;

public:
    explicit PackageClause(PackageName *package_name)
        : package_name_(std::move(package_name)) {}
    PackageName *package_name() const { return package_name_; }
    void accept(Visitor &visitor) override;
};

class String final : public Node {
private:
    std::string text_;

public:
    explicit String(std::string text) : text_(std::move(text)) {}
    const std::string &text() const { return text_; }
    void accept(Visitor &visitor) override;
};

class ImportSpec final : public Node {
private:
    std::string text_;

public:
    explicit ImportSpec(std::string text) : text_(std::move(text)) {}
    const std::string &text() const { return text_; }
    void accept(Visitor &visitor) override;
};

class ImportDecl final : public Node {
private:
    ImportSpec *import_spec_;
};

} // namespace go::ast