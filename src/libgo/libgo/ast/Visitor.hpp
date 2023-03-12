#pragma once

#include <libgo/ast/Ast.hpp>

namespace go::ast {

class Visitor {
public:
    virtual void visit(PackageName &value) = 0;
    virtual void visit(PackageClause &value) = 0;
    virtual void visit(ImportPath &value) = 0;
    virtual void visit(ImportDecl &value) = 0;
    virtual void visit(Type &value) = 0;
    virtual void visit(BasicType &value) = 0;
    virtual void visit(ArrayType &value) = 0;
};

} // namespace go::ast