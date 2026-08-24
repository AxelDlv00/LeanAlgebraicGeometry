Read-only audit complete. I loaded the Horizon skill first, checked protections/conversations, and made no edits, commits, or builds.

The existing APIs do not produce a binder-free arbitrary-field representation from `Pic0FiniteStageGluePackage` plus an object iso. `RepresentableBy.ofIso`, `ofObjectIso`, `ofLeftAdjoint`, and all Pic0 transport/descent helpers require an existing `RepresentableBy` witness. In particular, `pic0RepresentableBy_of_baseChangeObjectIso` (`Pic0RepresentableByTransport.lean:75-86`) transports a lower-field witness upward through an `Over` iso; it cannot descend a separably closed witness.

`finiteStageBaseChangeIso` (`Pic0FiniteStageGluedComparison.lean:284-292`) is only a raw `Scheme` iso
`pullback P.gluedMap ... ≅ (pic0_sepClosed_representableBy C).1.left`.
It has no `Over` structure-map compatibility, no Yoneda equivalence, and no `RepresentableBy` conclusion. The package itself contains only finite algebra/gluing data.

The smallest missing declaration is therefore the documented no-`rep` theorem of the form

```lean
pic0RepresentableBy_finiteStageGlue
  (P : Pic0FiniteStageGluePackage Ck F) :
  (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy P.gluedOver
```

with explicit base-change compatibility and a natural `homEquiv`/`homEquiv_comp` (equivalently, a natural iso `yoneda.obj P.gluedOver ≅ pic0TypeFunctor ...`). Existing finite-stage universal classes provide only elements/restriction identities, not this Yoneda bridge. A separate `Over`-bundled base-change iso is needed if `finiteStageBaseChangeIso` is used.

The finite-Galois theorem is a genuine consumer:

```lean
pic0RepresentableBy_finiteGaloisDescent
  ... (rep : (pic0TypeFunctor ((baseChange K L).obj C)).RepresentableBy J)
  [OrbitsInAffineOpen ...] :
  (pic0TypeFunctor C).RepresentableBy (gluedQuotientOver ...)
```

It still requires the extension representation, finite-dimensional/Galois hypotheses, and orbit-affine instance. No unconditional arbitrary-field `Σ J, ...` producer exists.

`rankOneAbelIso` only produces the rank-one divisor-locus isomorphism from an evaluation-divisor datum. Its canonical specialization is consumed by the separably closed chart and `pic0_sepClosed_representableBy`; it is neither the missing finite-stage producer nor an exact consumer of that bridge.
