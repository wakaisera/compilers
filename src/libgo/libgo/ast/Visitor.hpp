#pragma once

#include <libgo/ast/Ast.hpp>

namespace go::ast {

class Visitor {
public:
    virtual void visit(PackageName &value) = 0;
    virtual void visit(PackageClause &value) = 0;
    virtual void visit(ImportSpec &value) = 0;
};

} // namespace go::ast