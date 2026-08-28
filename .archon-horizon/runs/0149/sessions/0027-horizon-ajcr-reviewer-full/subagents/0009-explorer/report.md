Audit complete. The viable path is:

- Build the exact triple ring
  `Q U V W := OverlapRing U V ⊗[ChartRing U] OverlapRing U W`.
- Obtain its affine-section identification from
  `isPullback_opens_inf_le`, `isIso_pushoutSection_of_isAffineOpen`, and
  `CommRingCat.isPushout_tensorProduct`, following
  `DivisorSubschemeTensorOverlap.lean`.
- Coordinate the canonical `pic0SepClosedAtlasGlueData.t'` using overlap-to-spectrum isomorphisms and `pullbackSpecIso`.
- The induced ring map has direction
  `Q V W U →ₐ[k] Q U V W`; `t_fac` and `cocycle` transport contravariantly to the stated factor and cyclic identities.
- At the finite stage, use the current restriction models to form
  `B_UV ⊗[A_U] B_UW`. Its finite-type proof comes from the surjection out of
  `B_UV ⊗[M] B_UW`; `tensorProductPushoutBaseChange` then provides the base-change bridge needed for finite descent.

I sent the parent the detailed declaration names, orientations, and the one needed local lemma: prove that the canonical `GlueData.t'` coordinate map is over `Spec k` before promoting its global-sections map to a `k`-algebra hom. No files or Horizon state were modified.
