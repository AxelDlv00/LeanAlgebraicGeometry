# Iter-057 objectives (3 parallel mathlib-build lanes — all hard-gate cleared, build GREEN)

## Lane 1 — `CechAcyclic.lean`: change-of-ring seed `sectionCech_homology_exact_of_affineOpen` (NEW)
- Discharges `htilde` (the last Need#2 residual). Route B1: S=Γ(V) via M⊗_R S, per-σ base-change
  localization, polymorphic full-span core over S, ladder transport back.
- Blueprint: `lem:affine_cech_vanishing_general_seed`. Recipe: `analogies/genaffine-cech-seed.md`
  (+ `analogies/02kg-residual-changeofbase.md` for the D(f) sibling to mirror).
- ~230–320 LOC, multi-iter. Bar: per-σ iso + `hspan_S` + as much ladder as possible; hand off residual.

## Lane 2 — `CechSectionIdentification.lean`: Stub-1 sub-lemmas (NEW) + assemble `cechBackbone_left_sigma`
- effort-broken this iter. Close the 2 mechanical/independent sub-lemmas
  (`cechBackbone_obj_widePullback`, `widePullback_openImm_inter`); attack the hard
  `coproduct_distrib_fibrePower` (abstract `FinitaryPreExtensive` wide distributivity) + hand off.
- Blueprint: the Stub-1 split blocks. Recipe: `analogies/stub1-scheme-coproduct.md`.
- `Scheme` IS `FinitaryExtensive` (iter-056 "no Mathlib" was wrong for the binary case).

## Lane 3 — `OpenImmersionPushforward.lean`: Need#1 transport `modulesIsoSpecExtTransport` (NEW)
- Independent of Lanes 1–2. Whole-scheme `U≅SpecΓU` module-category EQUIVALENCE + `Ext.mapExactFunctor`.
- Blueprint: `lem:modules_isoSpec_ext_transport`. Recipe: `analogies/change-of-scheme-cohomology.md`.
- WALL TO AVOID: not an ambient→restricted `j^*` map (restriction-of-injectives wall). Do NOT touch the
  `_acyclic`/`_comp` residuals (306/372) — assembled next iter.

## Deferred to next iter
- Wire Lane-1 seed → `AffineSerreVanishing.affine_serre_vanishing_general_open` (one-shot consumer).
- Stub 2/4 then augmented Stubs 5/6 (`D'_aug`) → `hSec` in `CechAugmentedResolution`.
- `OpenImmersionPushforward` `_acyclic`/`_comp` assembly (needs Need#1 + Need#2).
- EnoughInjectives connector + P5a last-mile Ext-bridge → P5b assembly.
