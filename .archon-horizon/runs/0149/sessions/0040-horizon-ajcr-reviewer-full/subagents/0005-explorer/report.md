Audit complete and reported to the parent.

The future global comparison supports `RepresentableBy.ofIsoObj` only after it is lifted to an `Over (Spec k)` isomorphism. This yields the scalar-extended representation, not the finite-stage one. No API reflects representability backward across field base change.

The genuine missing datum is a finite-stage natural isomorphism
`yoneda.obj P.gluedOver ≅ pic0TypeFunctor ((baseChange K P.N.1).obj C)`.
Once available, the certificate is the one-liner
`(Functor.RepresentableBy.yoneda P.gluedOver).ofIso etaN`.

No files were edited.
