# Iter 024 — Objectives (per-lane detail)

## Lane 1 — FBC `Cohomology/FlatBaseChange.lean` [fine-grained]

**Target chain (bottom-up).** The three `inner_eCancel` atoms are frontier-ready (deps all proved) and do
NOT yet exist in Lean — create from the `% theorem` signature blocks in `Cohomology_FlatBaseChange.tex`
(~L2074–2170), prove each:

| Atom | effort | dep (proved) | content |
|---|---|---|---|
| `base_change_mate_inner_eCancel_eUnit` | 366 | `pullback_isEquivalence_of_iso` | unit of an adjunction with equivalence left adjoint is iso |
| `base_change_mate_inner_eCancel_pushforwardComp` | 443 | `gammaMap_pushforwardComp_hom_eq_id` | `pushforwardComp.hom` section value = id |
| `base_change_mate_inner_eCancel_pullbackComp` | 615 | `codomain_read`, `pullback_fst_snd_specMap_tensor` | `hom_inv_id_app` for a natural iso |

Then: de-sorry `inner_value_eq` @1577 (assemble atoms inline into the `inner_eCancel` cancellation; the
`inner_eCancel`/`inner_unitReduce` assembly nodes have NO standalone Lean decl by design; then
`unit_value` (Seam 1) + `inclA∘φ=inclR'∘ψ` transport). Then Seam B `gstar_generator_close` @1532 (element
identities `inner_value_apply`, `regroupEquiv_inv_one_tmul`). Then `gstar_transpose` @1760 (cite Seam C
`gstar_counit_transport` + inner_value_eq + generator_close).

**Do-not-retry:** `fstar_reindex`/`_legs` (dead @1421); whole-goal `rfl`/`simp`; per-generator brute force.
**Out of scope:** affine @1933, FBC-B @1955.

## Lane 2 — QUOT keystone `Picard/QuotScheme.lean` [mathlib-build]

**Build `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen`** (no Lean decl yet) from
`lem:qcoh_section_localization_basicOpen` (`Picard_QuotScheme.tex` ~L2470–2540). For quasi-coherent
`M : X.Modules`, affine open `U`, `f ∈ Γ(X,U)`: the restriction `M(U) → M(D(f))` is
`IsLocalizedModule (Submonoid.powers f)` over `Γ(X,U)`.

- Part (1): `IsAffineOpen.isLocalization_basicOpen` [verified] (ring localization `Γ(D(f)) = Γ(U)_f`).
- Part (2): over `U ≅ Spec Γ(X,U)`, qcoh = `Ñ` for `N := M(U)`; Spec-local `Γ(D(f),Ñ)=N_f` via
  `ModuleCat.Tilde.*` (`openToLocalization`) [verified-exists]; assemble `IsLocalizedModule` via
  `IsLocalizedModule.mk` / `.of_linearEquiv` [verified].

**mathlib-build:** bottom-up axiom-clean, no sorry; build intermediate qcoh↔tilde bridge lemmas as named
steps; if genuinely blocked, stop + hand off a precise decomposition (named missing ingredient).
**Why here:** shared bottom of GF-G1 + QUOT annihilator reverse direction; QuotScheme is its namespace home.
**Out of scope:** 4 protected stubs (@126/165/201/228), SNAP/GR frontier nodes.

## Deferred (with rationale)
- **GF-geo G1/G3** (`FlatteningStratification.lean`) — blocker `isLocalizedModule_basicOpen` is being built
  this iter (lane 2). Build G1 next iter once it lands (after a shared-extraction decision).
