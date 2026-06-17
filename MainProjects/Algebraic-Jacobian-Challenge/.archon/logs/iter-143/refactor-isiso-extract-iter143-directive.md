# Refactor Directive

## Slug
isiso-extract-iter143

## Problem

`AlgebraicJacobian/Cotangent/GrpObj.lean:701–721` defines
`relativeDifferentialsPresheaf_basechange_along_proj_two` whose body
constructs the named iso via:

```lean
  letI : IsIso (basechange_along_proj_two_inv G) :=
    isIso_of_app_iso_module (basechange_along_proj_two_inv G) (fun _ => sorry)
  (asIso (basechange_along_proj_two_inv G)).symm
```

The inner `(fun _ => sorry)` term sits inside a `letI` body and produces a
**sorry-tainted `IsIso` instance** that is consumed by `(asIso _).symm`.
Downstream consumers of `relativeDifferentialsPresheaf_basechange_along_proj_two G`
silently propagate the sorry through `simp`-rewrites and `apply` chains.

**`lean-auditor-review142` flagged this as MAJOR** (not must-fix because
the declaration's docstring is honest about the scaffold-with-tracked-sorry
nature, but the residual is hidden from naive audit reads).

**`progress-critic-iter143`** named extracting this residual into a
**named sorry-bodied theorem** as the primary CHURNING corrective:
it (a) restores audit transparency (the sorry becomes a visible
declaration sorry that `sorry_analyzer` + `lean_verify` both surface),
(b) narrows the iter-143 prover lane to the d_app sub-sorry (which is
~40–80 LOC; tractable), and (c) leaves IsIso as an independently-
scoped iter-144+ prover target on a clearly named obligation.

**`strategy-critic-iter143`** confirmed the diagnostic: IsIso is
**HYBRID — DEFINITION-LEVEL on the `letI` shape + RECIPE-LEVEL on
Route (b'2) items 2–4**. This refactor addresses the definition-level
half.

## Mathematical Justification

The IsIso obligation is **mathematically unchanged** before and after
the refactor. The `letI = isIso_of_app_iso_module ... (fun _ => sorry)`
form folds the per-open `IsIso` obligation into the `(fun _ => sorry)`
argument; the refactor lifts it to a named theorem with the same per-open
content:

```lean
theorem basechange_along_proj_two_inv_app_isIso
    (G : Over (Spec (.of k))) [CategoryTheory.GrpObj G]
    {n : ℕ} [SmoothOfRelativeDimension n G.hom]
    [IsProper G.hom] [GeometricallyIrreducible G.hom]
    (X : G.left.Opensᵒᵖ) :
    IsIso ((basechange_along_proj_two_inv G).app X) := by
  sorry
```

(The signature can also be packaged as the bundled `IsIso (basechange_along_proj_two_inv G)`
directly if that's cleaner; both shapes work. The per-open shape is
preferred because `isIso_of_app_iso_module` is the bridge that
de-bundles `IsIso f` into `∀ X, IsIso (f.app X)`, so the natural Lean
shape of the residual obligation IS per-open.)

Then the consuming declaration becomes:

```lean
noncomputable def relativeDifferentialsPresheaf_basechange_along_proj_two
    (G : Over (Spec (.of k))) [CategoryTheory.GrpObj G]
    {n : ℕ} [SmoothOfRelativeDimension n G.hom]
    [IsProper G.hom] [GeometricallyIrreducible G.hom] :
    Scheme.relativeDifferentialsPresheaf (fst G G).left ≅
      (PresheafOfModules.pullback
          (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom).obj
        (Scheme.relativeDifferentialsPresheaf G.hom) :=
  letI : IsIso (basechange_along_proj_two_inv G) :=
    isIso_of_app_iso_module (basechange_along_proj_two_inv G)
      (basechange_along_proj_two_inv_app_isIso G)
  (asIso (basechange_along_proj_two_inv G)).symm
```

Note that the `letI` form is **retained** — what changes is that its
`(fun _ => sorry)` argument becomes a reference to the new named
theorem. The new named theorem becomes the single auditable site of
the sorry.

The closure path of `basechange_along_proj_two_inv_app_isIso` (Route
(b'2) items 2+3+4 per `analogies/isiso-basechange-along-proj-two-inv.md`)
is **the same** as the closure path that was previously embedded in the
`(fun _ => sorry)`:

- (2) Chart-level `Algebra.IsPushout`-from-affine-product helper (~80–150 LOC).
- (3) `((pullback ψ).obj M).obj X` chart-unfolding helper `pullbackObjEquivTensor` (~30–60 LOC).
- (4) Per-open identification with `KaehlerDifferential.tensorKaehlerEquiv.symm`
      via `tensorKaehlerEquiv_symm_D_tmul` (~80–150 LOC).

Total envelope ~195–365 LOC, **unchanged** by this refactor.

## Changes Requested

### Single file: `AlgebraicJacobian/Cotangent/GrpObj.lean`

**Change 1: Insert new named theorem** between `basechange_along_proj_two_inv`
(currently L685–L699) and `relativeDifferentialsPresheaf_basechange_along_proj_two`
(currently L701–L721). Place it immediately before
`relativeDifferentialsPresheaf_basechange_along_proj_two`.

Add docstring on the new theorem:

```lean
/-- **Per-open IsIso obligation** for the inverse-direction morphism
`basechange_along_proj_two_inv G` (piece (i.b) Step 2 IsIso sub-piece).

Iter-143 refactor: extracts the IsIso residual that previously lived
inside the `letI := isIso_of_app_iso_module ... (fun _ => sorry)` body
of `relativeDifferentialsPresheaf_basechange_along_proj_two` into a
named sorry-bodied theorem. The mathematical content is unchanged; the
refactor restores audit transparency (per `lean-auditor-review142`
MAJOR + `progress-critic-iter143` CHURNING primary corrective).

**Closure path** (Route (b'2) per `analogies/isiso-basechange-along-proj-two-inv.md`
Decision 2; item 1 = `isIso_of_app_iso_module` closed iter-140):
- Items 2–4 (~195–365 LOC bundled): chart-level
  `Algebra.IsPushout`-from-affine-product (~80–150 LOC) + per-open
  chart-unfolding `pullbackObjEquivTensor` (~30–60 LOC) + per-open
  identification with `KaehlerDifferential.tensorKaehlerEquiv.symm`
  via `tensorKaehlerEquiv_symm_D_tmul` (~80–150 LOC).
- See `RigidityKbar.tex:943–1073` for the prose decomposition. -/
theorem basechange_along_proj_two_inv_app_isIso
    (G : Over (Spec (.of k))) [CategoryTheory.GrpObj G]
    {n : ℕ} [SmoothOfRelativeDimension n G.hom]
    [IsProper G.hom] [GeometricallyIrreducible G.hom]
    (X : G.left.Opensᵒᵖ) :
    IsIso ((basechange_along_proj_two_inv G).app X) := by
  sorry
```

**Change 2: Modify** the body of `relativeDifferentialsPresheaf_basechange_along_proj_two`
at currently L709–L721 from:

```lean
  -- Iter-138 partial closure: build the iso via the inverse map +
  -- `IsIso`-of-inverse + `asIso ... |>.symm`. The `IsIso` fact is the
  -- third concrete sub-piece; see this declaration's docstring for the
  -- closure paths (Route (a) chart-unfolding-helper or local-iso check).
  -- Iter-140 structural refactor: Route (b'2) via the iso-reflection
  -- bridge `isIso_of_app_iso_module` localises the IsIso check to a
  -- per-open ModuleCat-iso check; the remaining per-open identification
  -- (against `KaehlerDifferential.tensorKaehlerEquiv.symm` modulo the
  -- chart-unfolding of `((pullback ψ).obj M_G).obj X`) is the residual
  -- iter-141+ closure target.
  letI : IsIso (basechange_along_proj_two_inv G) :=
    isIso_of_app_iso_module (basechange_along_proj_two_inv G) (fun _ => sorry)
  (asIso (basechange_along_proj_two_inv G)).symm
```

to:

```lean
  -- Iter-138 partial closure: build the iso via the inverse map +
  -- `IsIso`-of-inverse + `asIso ... |>.symm`. Iter-140 structural
  -- refactor: Route (b'2) via the iso-reflection bridge
  -- `isIso_of_app_iso_module` localises the IsIso check to a per-open
  -- ModuleCat-iso check. Iter-143 refactor: the per-open `IsIso`
  -- obligation is extracted into the named sorry-bodied theorem
  -- `basechange_along_proj_two_inv_app_isIso` (above) per
  -- `lean-auditor-review142` MAJOR + `progress-critic-iter143` CHURNING
  -- primary corrective; the residual `sorry` now lives in that named
  -- theorem and is audit-visible.
  letI : IsIso (basechange_along_proj_two_inv G) :=
    isIso_of_app_iso_module (basechange_along_proj_two_inv G)
      (basechange_along_proj_two_inv_app_isIso G)
  (asIso (basechange_along_proj_two_inv G)).symm
```

## Affected Files

Only `AlgebraicJacobian/Cotangent/GrpObj.lean` is touched. No other file
references the IsIso residual; the file is currently the only consumer
of `(asIso (basechange_along_proj_two_inv G)).symm` (downstream is
`mulRight_globalises_cotangent` which `sorry`s its body and does not
yet consume the IsIso fact).

`archon-protected.yaml` does **not** list any declaration in this file
under the protected surface; this refactor is signature-stable for all
exposed names.

## Expected Outcome

After the refactor:
- `sorry_analyzer` reports **3 inline `sorry`** in `Cotangent/GrpObj.lean`
  (was 3 before refactor; unchanged in count — the refactor moves one
  `sorry` from being embedded in a `letI` body to being the body of a
  new named theorem). The 3 are:
  - `basechange_along_proj_two_inv_derivation` d_app sub-sorry
    (currently L637, post-refactor L-shifted by ~26 lines from the new
    theorem insertion).
  - **NEW** `basechange_along_proj_two_inv_app_isIso` body `sorry`
    (the extracted IsIso residual; ~1 LOC body sorry post-refactor).
  - `mulRight_globalises_cotangent` Main body sorry (currently L848,
    post-refactor L-shifted).
- **Sorry count by declarations**: was 3 in this file; now **4**
  (the extracted theorem adds 1 sorry-bodied declaration); net +1
  declaration with sorry. *This is the correct outcome*: the IsIso
  obligation that was previously hidden inside a `letI` body is now an
  auditable named declaration. Per `sorry_analyzer` decls=count rule,
  this is +1 declaration / 0 inline net change (the `(fun _ => sorry)`
  → named-theorem call swap conserves the inline count; the new
  theorem's body adds 1 inline + 1 decl).
- **File LOC**: +~26 LOC (the new theorem + docstring) vs the deleted
  comment block + `(fun _ => sorry)` argument.
- **Compile-clean**: `lean_diagnostic_messages` on `Cotangent/GrpObj.lean`
  should return `success: true` with 4 `declaration uses sorry`
  warnings (was 3); no new errors.

After the refactor, the iter-143 prover lane targets ONLY the d_app
sub-sorry inside `basechange_along_proj_two_inv_derivation`. The
extracted `basechange_along_proj_two_inv_app_isIso` is deferred to
iter-144+ as a separate prover round on Route (b'2) items 2–4.

**Do NOT modify**:
- `basechange_along_proj_two_inv_derivation` (the d_app sub-sorry stays
  for the iter-143 prover lane).
- `basechange_along_proj_two_inv` (the inverse-direction term-mode
  construction; unrelated to this refactor).
- `isIso_of_app_iso_module` (the private iso-reflection helper; this
  refactor *uses* it via the named theorem, doesn't change it).
- `mulRight_globalises_cotangent` (Main; iter-143+ target, body sorry).
- Anything in `Jacobian.lean` / `RigidityKbar.lean` / other files.

## Verification after refactor

After your edits, run `sorry_analyzer` on `Cotangent/GrpObj.lean` and
confirm: 4 inline sorries (was 3); 4 sorry-bodied declarations (was 3).
Run `lean_diagnostic_messages` on the file and confirm success: true
with no new errors beyond the expected sorry warnings. Report both
results in your task_results file.
