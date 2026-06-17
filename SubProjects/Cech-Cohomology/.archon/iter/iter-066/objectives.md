# Iter-066 objectives

Two `prove` lanes; both files' blueprint gate cleared by blueprint-reviewer `iter066`.

## Lane 1 — `CechSectionIdentification.lean` (`prove`)
- Stub 5 `cechSection_complex_iso` (sorry 1418) — augmented degreewise iso → complex iso via
  `pushPull_eval_prod_iso` (Stub 4, DONE) + `sectionCech_objD_apply` differential match +
  `HomologicalComplex.mkIso`; navigate the `Kp` type adapter.
- Stub 6 `cechSection_contractible` (sorry 1477) — `Homotopy (𝟙 (…augment ε hε)) 0`; positive degrees via
  `CombinatorialCech.depHomotopy`, degree-0 augmentation node via the explicit `π_{i_fix}` identity.
- Housekeeping: update module docstring (10–34); prune stale `cechBackbone_left_sigma` comment (582–610).
- Bar: both close → CSI sorry-free → `hSec` wireable. Stub 6 the harder; if it stalls, close Stub 5 + hand off.

## Lane 2 — `OpenImmersionPushforward.lean` (`prove`)
- `_comp` 4 sub-sorries: hacyc (974) / eRes (979) / hexact (982) / transport (985).
- ⚠ FOLLOW THE BLUEPRINT (rewritten part (2)), NOT the in-file `hacyc` comment 960–964 (flawed Serre-vanishing
  route).
- hacyc: `Injective (K.X n = j_* Iⁿ)` via `Injective.injective_of_adjoint (pullbackPushforwardAdjunction j)`
  + `[PreservesMonomorphisms (pullback j)]` (from `restrictFunctorIsoPullback`); then `IsRightAcyclic.ofInjective`
  (instance) gives acyclicity.
- hexact: `H^{n+1}(K) = R^{n+1} j_* H = 0` by `higherDirectImage_openImmersion_acyclic` (DONE).
- eRes: left-exact augmentation `j_* H ≅ K.cycles 0`. transport: `pushforwardComp` + `isoRightDerivedObj`.
- Bar: all 4 → `_comp` sorry-free → P5a-consumer DONE. Non-mechanical risk = `PreservesMonomorphisms (pullback j)`.

## Not lanes
- `CechAugmentedResolution.lean` hSec (229) — downstream of Lane 1; wire next iter.
- `CechHigherDirectImage.lean` P5b (780, frozen) — gated on P5a inputs.
- `CechAcyclic.affine` (110, dead) — deletion refactor (non-blocking cleanup).
