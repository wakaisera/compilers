#include <libgo/ast/Ast.hpp>

#include <libgo/ast/Visitor.hpp>

namespace go::ast {

void PackageName::accept(Visitor &visitor) { visitor.visit(*this); }

void PackageClause::accept(Visitor &Visitor) { Visitor.visit(*this); }

void ImportSpec::accept(Visitor &visitor) { visitor.visit(*this); }

} // namespace go::ast