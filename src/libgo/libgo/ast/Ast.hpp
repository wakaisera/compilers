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

class ImportPath final : public Node {
private:
    std::string text_;

public:
    explicit ImportPath(std::string text) : text_(std::move(text)) {}
    const std::string &text() const { return text_; }
    void accept(Visitor &visitor) override;
};

class ImportDecl final : public Node {
private:
    ImportPath *import_path_;

public:
    explicit ImportDecl(ImportPath *import_path)
        : import_path_(std::move(import_path)) {}
    ImportPath *import_spec() const { return import_path_; }
    void accept(Visitor &visitor) override;
};

class Type : public Node {
public:
    virtual ~Type() = default;
    virtual void accept(Visitor &visitor) = 0;
};

class BasicType final : public Type {
private:
    std::string text_;

public:
    explicit BasicType(std::string text) : text_(std::move(text)) {}
    const std::string &text() const { return text_; }
    void accept(Visitor &visitor) override;
};

class ArrayLength final: public Node {};

class ArrayType final : public Type {
private:
    ArrayLength *array_length_;
    BasicType *basic_type_;

public:
    ArrayType(ArrayLength *array_length, BasicType *basic_type)
        : array_length_(std::move(array_length)),
          basic_type_(std::move(basic_type)) {}
    ArrayLength *array_length() { return array_length_; }
    BasicType *basic_type() { return basic_type_; }
    void accept(Visitor &visitor) override;
};

// class QualifiedIdent final : public Node {
// private:
//     PackageName *package_name_;

// public:
//     explicit QualifiedIdent(PackageName *package_name)
//         : package_name_(std::move(package_name)) {}
//     PackageName *package_name() const { return package_name_; }
//     void accept(Visitor &visitor) override;
// };

// class TypeName final : public Node {
// private:
//     QualifiedIdent *qualified_ident_;
// public:
//     explicit TypeName(QualifiedIdent *qualified_ident)
//         : qualified_ident_(std::move(qualified_ident)) {}
//     QualifiedIdent *qualified_ident() const { return qualified_ident_; }
//     void accept(Visitor &visitor) override;
// };

} // namespace go::ast