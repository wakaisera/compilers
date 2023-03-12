#include <libgo/ast/Ast.hpp>

#include <libgo/ast/Visitor.hpp>

namespace go::ast {

void PackageName::accept(Visitor &visitor) { visitor.visit(*this); }

void PackageClause::accept(Visitor &visitor) { visitor.visit(*this); }

void ImportPath::accept(Visitor &visitor) { visitor.visit(*this); }

void ImportDecl::accept(Visitor &visitor) { visitor.visit(*this); }

void Type::accept(Visitor &visitor) { visitor.visit(*this); }

void BasicType::accept(Visitor &visitor) { visitor.visit(*this); }

void ArrayType::accept(Visitor &visitor) { visitor.visit(*this); }

} // namespace go::ast