# Iter-225 objectives detail — Lane TS.dual sub-step 4: the sheaf-level dual

Funded block A.1.c.SubT.dual (sheaf internal-hom / dual of 𝒪_X-modules), elapsed 6 of ~6–12 iters.
Sub-steps RETIRED: 1 (value module, iter-219), 2 (presheaf `internalHom` + restriction, iter-220),
3 (presheaf `dual` + evaluation `internalHomEval`, iters 221→224, closed axiom-clean iter-224).
THIS iter retires **sub-step 4**: the sheaf-level dual object `AlgebraicGeometry.Scheme.Modules.dual`.

Gate status: blueprint-reviewer ts225 → **HARD GATE CLEARS** for `lem:internal_hom_isSheaf`
(`Picard_TensorObjSubstrate.tex` complete+correct, target well-named). progress-critic ts225 →
**CONVERGING**, dispatch sanity OK (1 file, in scope, ≈1–2 iter closure analogous to sub-steps 1/2).

**Mode:** `[prover-mode: mathlib-build]` — build a NEW axiom-clean decl (no project sorry to close;
the dual OBJECT does not yet exist in Lean). No sorry in output: each piece fully proved or absent,
with a precise hand-off decomposition if blocked.

## File: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` [prover-mode: mathlib-build]

Blueprint: `chapters/Picard_TensorObjSubstrate.tex` §`sec:tensorobj_dual_infra`, block
`lem:internal_hom_isSheaf` → `\lean{AlgebraicGeometry.Scheme.Modules.dual}`. Source:
`references/stacks-modules.tex` (§Internal Hom, tag area 01CM, L3502–L3514: "this is a sheaf of
abelian groups … Hence we in fact get a sheaf of 𝒪_X-modules"); local-triviality of the dual is
Stacks tag 01CR item 2 (L4200–L4213).

### PRIMARY target — `AlgebraicGeometry.Scheme.Modules.dual` (the sheaf-level dual object)

Build, in namespace `AlgebraicGeometry.Scheme.Modules`:
```
noncomputable def dual {X : Scheme.{u}} (M : X.Modules) : X.Modules
```
the sheaf-level dual `ℋom_{𝒪_X}(M, 𝒪_X) ∈ Scheme.Modules X` (= `SheafOfModules X.ringCatSheaf`).

**Construction — follow the EXISTING in-file `tensorObj` precedent EXACTLY** (TensorObjSubstrate.lean
L1524). `tensorObj` lands a `SheafOfModules` object by applying the sheafification functor to the
presheaf-level primitive:
```
noncomputable def tensorObj {X : Scheme.{u}} (M N : X.Modules) : X.Modules :=
  ((PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).obj
      (PresheafOfModules.Monoidal.tensorObj (R := X.presheaf) M.val N.val) :
    SheafOfModules X.ringCatSheaf)
```
The exact dual analogue, replacing the presheaf tensor by the (axiom-clean, sub-step-3) presheaf
dual `PresheafOfModules.dual`:
```
noncomputable def dual {X : Scheme.{u}} (M : X.Modules) : X.Modules :=
  ((PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).obj
      (PresheafOfModules.dual (R₀ := ?) M.val) : SheafOfModules X.ringCatSheaf)
```
The sheafification functor already lands in `SheafOfModules` — **no manual sheaf-condition descent /
`Presheaf.IsSheaf` proof is required** (the blueprint's "internal hom into a sheaf is already a sheaf"
is realized here by sheafifying; sheafifying an already-sheaf gives an iso object, which is the project
convention used everywhere in this file). This is why the blueprint pin is the OBJECT `dual`, not a
standalone `isSheaf` lemma (blueprint-reviewer ts225 confirms).

**KNOWN PLUMBING SUBTLETY — the CommRingCat/RingCat base mismatch (the only real obstacle).**
`PresheafOfModules.dual` (TensorObjSubstrate.lean L1356) is stated over
`R₀ ⋙ forget₂ CommRingCat RingCat` with `R₀ : Dᵒᵖ ⥤ CommRingCat.{u}` — it needs the CommRingCat
structure (the value `M^∨(U) = M|_U ⟶ R|_U` is an `R(U)`-MODULE, which requires commutativity).
`tensorObj` uses `(R := X.presheaf)` over plain RingCat. So you must exhibit `X.presheaf` (or the
form `M.val`'s base takes) as `R₀ ⋙ forget₂ CommRingCat RingCat` for the scheme's CommRingCat-valued
structure sheaf `R₀`. Schemes have commutative structure sheaves, so this bridge exists; it is the
same CommRingCat/RingCat diamond the sub-step-2/3 provers cracked via an explicit `@ofPresheaf`
instance + single-universe `Opens X` base (see iter-220 memory `ts219-internalhom-value-built` and the
in-file `ofPresheaf` discussion ≈L1262–1290). Reuse that bridge; do NOT re-derive it. If the base
coercion is genuinely sticky, that is the precise hand-off point — name exactly which composite does
not reduce to the `R₀ ⋙ forget₂` form.

### SECONDARY (budget-allowing, bottom-up — do NOT sorry-pin; build or hand off cleanly)

Once `dual` is axiom-clean, as far as budget allows (mathlib-build "go as far as you can"):
1. `AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial` (`lem:dual_isLocallyTrivial`,
   `\uses{lem:internal_hom_isSheaf, lem:tensorobj_restrict_iso}`): `IsLocallyTrivial L →
   IsLocallyTrivial (dual L)`. On a trivialising open `L|_U ≅ 𝒪_U`, the internal hom commutes with
   open-immersion restriction (the dual analogue of the closed `tensorObj_restrict_iso`), so
   `(dual L)|_U ≅ ℋom_{𝒪_U}(𝒪_U,𝒪_U) ≅ 𝒪_U` (evaluation at 1). Stacks 01CR item 2.
2. The descended evaluation `M ⊗_X dual M → 𝒪_X`: sheafify `internalHomEval` via the sheafification
   functor `.map`, exactly as `tensorObj_unit_iso` (L1600) lifts a presheaf counit through
   `(PresheafOfModules.sheafification …).mapIso`/`.map` + the `sheafificationAdjunction` unit. This is
   the descended counit `rem:dual_discharges_inverse` needs. (Blueprint-reviewer flagged the prose
   here elides the sheafification universal-property step — it is the `toSheafify`/adjunction-unit
   bridge already used in-file; not a math gap.)

These two SECONDARY items + `exists_tensorObj_inverse` (sub-step 5, FORBIDDEN this iter) are the
remaining dual-block deliverables. Retiring just PRIMARY `dual` this iter is a full sub-step-4 success.

### Reuse (do NOT re-derive)
`PresheafOfModules.dual`, `PresheafOfModules.internalHomEval` (axiom-clean), `PresheafOfModules.
sheafification`, `sheafificationAdjunction`, the in-file `@ofPresheaf` CommRingCat/RingCat bridge, and
the `tensorObj` / `tensorObj_unit_iso` construction templates (same file).

### Success bar
- `lean_verify AlgebraicGeometry.Scheme.Modules.dual` = `{propext, Classical.choice, Quot.sound}`
  (axiom-clean; no `sorryAx`).
- Build GREEN; project sorry count unchanged at 80 (this is no-sorry infra — `dual` adds a clean decl,
  does NOT close a project sorry; sub-step 5 `exists_tensorObj_inverse` is what eventually moves 80→79).
- Sub-step 4 RETIRED (the sheaf-level `dual` object exists axiom-clean). SECONDARY items are a bonus.

### FORBIDDEN this iter
- Do NOT `prove`/pin `exists_tensorObj_inverse` (L1935, sub-step 5) or `addCommGroup_via_tensorObj`
  (L1981, RPF consumer) — iter-214 d.1 anti-pattern. The `dual` object is the prerequisite; wiring it
  into `exists_tensorObj_inverse` is the NEXT sub-step, not this one.
- Do NOT touch `tensorObj_assoc_iso`'s PROOF or delete the still-live whiskering decls (`isLocally
  Injective_whiskerLeft_of_W` L641 and friends — vestigial, deletion deferred with the assoc re-route).
- Do NOT raise `set_option maxHeartbeats` to brute-force any defeq (cost is structural, not budget).
- Do NOT undertake the 14-site `Sheaf.val` → `ObjectProperty.obj` deprecation migration.
- Do NOT write a `Presheaf.IsSheaf` proof for the internal hom — the sheafification-functor route
  (matching `tensorObj`) makes it unnecessary; if you find yourself proving the sheaf condition by
  hand, stop and use sheafification.

### If blocked
mathlib-build "stops only when genuinely blocked." If the CommRingCat/RingCat base bridge for
`PresheafOfModules.dual M.val` cannot be made to typecheck against `X.presheaf`/`X.ringCatSheaf`,
hand off the EXACT composite that fails to reduce to `R₀ ⋙ forget₂ CommRingCat RingCat`, and whether
the obstacle is the universe (`Opens X` single-universe) or the CommRingCat-projection. That is a
precise, actionable hand-off — not a sorry pin.
