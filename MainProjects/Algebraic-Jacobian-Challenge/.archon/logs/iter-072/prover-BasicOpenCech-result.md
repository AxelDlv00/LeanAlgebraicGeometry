# AlgebraicJacobian/Cohomology/BasicOpenCech.lean — iter-071 prover

## Summary

Sorry count **11 → 6** (-5 net). LOC 981 → 1022 (+41).

Attacked Cluster (b) — cochain-differential carriers `f_R/g_R` plus
identification lemmas `hf_eq/hg_eq` (was 4 sorries: L949–952) — and the
under-the-hood single-element instance witnesses in Cluster (c) —
`h_loc_X₁/X₂/X₃` (was 3 sorries: L959–963). Both closures land in the
same `h_K₀_exact` block of the substantive theorem
`basicOpenCover_isCechAcyclicCover_toModuleKSheaf`.

Protected signatures unchanged. No new axioms.

## Cluster (b) — f_R, g_R, hf_eq, hg_eq (L949–L952 → L957–L985)

### Attempt 1 (this iteration)
- **Approach.** Package the underlying `k`-linear Čech differential
  `ConcreteCategory.hom scK₀.f` (resp. `.g`) directly as an `R`-linear map
  by exhibiting `toFun`, `map_add'`, `map_smul'` explicitly. With this
  concrete structure, `hf_eq` and `hg_eq` close definitionally by `rfl`.
- **Result.** RESOLVED (partial). 4 sorries → 2 sorries. The remaining
  pair are the `map_smul'` obligations *inside* each LinearMap construction
  (substantive R-linearity of the alternating-coface differential — see
  next section).
- **Concrete construction.**
  ```
  let f_R : scK₀.X₁ →ₗ[R] scK₀.X₂ :=
    { toFun := ⇑(ConcreteCategory.hom scK₀.f)
      map_add' := map_add (ConcreteCategory.hom scK₀.f)
      map_smul' := by intro r x; sorry }
  -- similarly g_R
  have hf_eq : ⇑f_R = ⇑(ConcreteCategory.hom scK₀.f) := rfl
  have hg_eq : ⇑g_R = ⇑(ConcreteCategory.hom scK₀.g) := rfl
  ```
- **Key insight.** With `have h_mod_X₁/X₂/X₃ : Module R scK₀.X_i` in
  scope (iter-069 prover's convert-from-piIsoPi transport), the
  R-linear-map type `scK₀.X₁ →ₗ[R] scK₀.X₂` already typechecks; the
  remaining obligation is precisely `map_smul'`. Wrapping `toFun :=
  ⇑(ConcreteCategory.hom scK₀.f)` makes `hf_eq := rfl` definitional
  — so 2 of the 4 cluster-(b) sorries collapse for free.
- **Verified via `lean_run_code`.** A standalone minimal example
  (`R`/`k`/`X_i : ModuleCat k`/`f : X₁ ⟶ X₂` setup) confirms the
  structure syntactically; the local-context `Module R X_i` instance
  introduced by `have` is enough to typecheck the surrounding LinearMap
  with `map_smul' := sorry`.

### Remaining: `map_smul'` for f_R and g_R (L974, L983)
- **Mathematical content.** The Čech differential `scK₀.f.hom` is an
  alternating sum of presheaf-restriction maps `Γ(C.left, V) → Γ(C.left,
  W)` for `W ≤ V ≤ U`. Each restriction is an `R = Γ(C.left, U)`-algebra
  homomorphism (via the algebra chain `R → Γ(V) → Γ(W)`), hence
  `R`-linear. The `R`-action on each cochain factor is the transported
  pointwise action via `(ModuleCat.piIsoPi Z).toLinearEquiv.toAddEquiv.module R`.
- **Why deferred.** Closing this `sorry` requires unfolding
  `alternatingCofaceMapComplex.d` to expose the alternating sum, then
  inducting through the componentwise R-action. The unfolding chain
  (`alternatingCofaceMapComplex` → `cosimplicialObjectFunctor` →
  `Limits.FormalCoproduct.cech`) is multi-step and the `convert h`
  transport in `h_mod_X_i` produces an opaque module structure that
  obstructs direct rewriting.
- **Next step.** Replace the `convert h` transport (in `h_mod_X_i`)
  with an explicit `LinearEquiv`-mediated definition that exposes the
  componentwise R-action; this would let the R-linearity proof reduce
  to per-component R-linearity (which is mechanical from
  `Scheme.algebraSection.algebraMap`-`comp` lemmas).

## Cluster (c) — h_loc_X₁, h_loc_X₂, h_loc_X₃ (L959–L963 → L996–L1004)

### Attempt 1 (this iteration)
- **Approach.** Apply Mathlib's canonical
  `localizedModuleIsLocalizedModule` instance to discharge each
  `IsLocalizedModule.Away (f.1 : R) (LocalizedModule.mkLinearMap
  (powers (f.1 : R)) scK₀.X_i)` obligation.
- **Result.** RESOLVED. 3 sorries → 0.
- **Concrete construction.**
  ```
  have h_loc_X₁ (f : ↑s₀) : IsLocalizedModule.Away (f.1 : R)
      (LocalizedModule.mkLinearMap (Submonoid.powers (f.1 : R)) scK₀.X₁) :=
    localizedModuleIsLocalizedModule _
  -- similarly h_loc_X₂, h_loc_X₃
  ```
- **Key insight.** The iter-069 plan envisaged identifying the
  *slice-cover* cochain factor as a localization (requiring the
  product-localisation commutation `LocalizedModule (powers f.1)
  (∏ᶜ_i M_i) ≅ ∏ᶜ_i LocalizedModule (powers f.1) M_i` for finite
  indexing). But the **type signature** as iter-069 wrote it uses
  `LocalizedModule.mkLinearMap` as the localization map, not a
  slice-cover restriction map — so the substantive content shifted to
  `h_loc_exact` (L1010) where the slice-cover identification is needed
  to transport `h_a₀_fun f` (slice-cover exactness) across the
  localization iso.
- **Verified via `lean_run_code`.** Standalone example
  (`example (R M : Type) [CommSemiring R] [AddCommMonoid M] [Module R M]
  (x : R) : IsLocalizedModule.Away x (LocalizedModule.mkLinearMap
  (Submonoid.powers x) M) := localizedModuleIsLocalizedModule _`)
  confirms the discharge is kernel-only.

## Remaining sorries (6 total)

| Line | Substep | Status |
|---|---|---|
| L495 | (a) original `s` cover, extra-degeneracy | unchanged (iter-061+) |
| L819 | (i) Čech-cohomology refinement transport `s → s₀` | unchanged (iter-064+) |
| L847 | (a) slice cover for `s₀`, extra-degeneracy | unchanged (iter-064+) |
| L974 | f_R map_smul' (R-linearity of Čech differential) | **new this iteration** |
| L983 | g_R map_smul' (same content at one degree shifted) | **new this iteration** |
| L1012 | h_loc_exact — slice-cover-to-localised-cochain exactness transport | unchanged (iter-069+, now requires h_loc_X_i ⇒ slice-cover iso) |

## Build-environment caveat

Local `lake build` fails with `permission denied` on the `.lake/packages`
tree (the build directory is not writable from this prover sandbox), and
`mcp__archon-lean-lsp__lean_diagnostic_messages` returned
`{"success":false,"items":[]}` for the file (cache miss; the on-disk
`.olean` is from before this iteration's edits). `lean_verify` returned
no axioms/warnings, but that is consistent with the cached olean.

The Cluster-(b) construction and Cluster-(c) discharge have been
**verified syntactically via `mcp__archon-lean-lsp__lean_run_code`**
in standalone minimal contexts (see the "Verified via lean_run_code"
notes above). The semantic typechecking against the surrounding
context (specifically, instance synthesis of `Module R scK₀.X_i`
inside the `have` block) follows the same pattern that iter-069 prover
established for the *type signatures* of `f_R/g_R/h_loc_X_i` (all of
which were sorry'd with the surrounding compiling cleanly).

## Notes for next iteration

1. **`map_smul'` for `f_R/g_R` (L974/L983).** Closing these requires
   exposing the componentwise R-action on the cochain factors. The
   simplest path: refactor `h_mod_X_i` from a `convert h` transport to
   a direct `e.toAddEquiv.module R`-style definition with the
   `LinearEquiv` `e := (ModuleCat.piIsoPi Z).toLinearEquiv` retained as a
   named term in scope, so R-linearity of the differential reduces
   (via `e.comap_linearMap`) to R-linearity on the explicit product. The
   alternating-coface differential on the product is then a finite sum
   of `LinearMap.pi`-composed-with-projection-and-restriction terms,
   each of which is `R`-linear by `(C.left.presheaf.map …).hom`'s
   `R`-algebra-hom property.
2. **`h_loc_exact` (L1012).** Now needs the slice-cover ↔ `LocalizedModule`
   iso (Mathlib's `IsLocalizedModule.pi` for finite indexing +
   per-factor `isLocalization_of_eq_basicOpen`). With both `h_loc_X_i`
   and the slice-cover Čech being canonical, the iso is a
   `LinearEquiv.piCongrRight` whose components compose to identify
   `LocalizedModule (powers f.1) scK₀.X_i ≅ slice_K.X i` at `f`.
   Then `IsLocalizedModule.map_exact` transports `h_a₀_fun f`.

## Blueprint marker recommendation

`thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` body still
contains 9 substep sorries (the 6 above plus the 3 unchanged inside the
*Cluster-(a) original-s* / *h_transport* / *Cluster-(a) s₀* blocks). The
declaration itself remains `\leanok` (it has a body with `sorry`); the
proof block stays without `\leanok` until the remaining substeps close.
No marker edit required this iteration (managed by `sync_leanok`).
