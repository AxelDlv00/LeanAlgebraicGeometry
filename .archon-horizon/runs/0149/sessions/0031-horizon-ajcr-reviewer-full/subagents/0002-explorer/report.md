Exact import cycle and endpoint wiring were sent to `/root`.

Key update: the shared tree now contains untracked finite-stage bridge modules. They establish `gluedOver`, final-stage ring base-change equivalences, and map naturality, but still do not construct a `RepresentableBy` or the required glued-scheme base-change isomorphism.

After `pic0_representableBy`, the honest handoff remains:

```lean
PicRepDatum k k C
+ QuasiCompact d.J.hom
→ d.toJacobianData hqc
→ Jacobian := (jacobianData C).J
```

Group structure, Abel map, pointing law, contravariant functor maps/laws, and the base-change comparison then have existing datum-level producers. Smooth relative dimension, properness/geometric irreducibility, Albanese existence, base-change coherence, and Abel base-change compatibility remain separate obligations. No files or Horizon state were changed.
