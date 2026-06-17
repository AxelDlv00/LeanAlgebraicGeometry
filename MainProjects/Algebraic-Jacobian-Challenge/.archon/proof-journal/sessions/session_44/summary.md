# Session 44 — iter-044 review

## Metadata

- **Archon iteration**: 044
- **Stage**: prover (Phase A step 6 *Path 2* / Serre-finiteness scaffolding — **geometric Stein input** for the iter-043 wholespace H⁰ Hom-finiteness carrier)
- **File touched**: `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` (single file)
- **Sorry count before**: 9 (project-wide non-archon)
- **Sorry count after**: 9 (unchanged — body fully closed; no transient scaffold sorries)
- **LOC delta on the touched file**: 548 → 615 (+67) — the iter-044 plan estimate was "+~50 LOC"; actual +67 (docstring ~30 lines + body ~37 lines after the explicit `Opposite.op` qualifications). Slightly above estimate but within iteration budget.
- **Attempts (raw events from `attempts_raw.jsonl`)**: 2 substantive Edits (initial verbatim plan-agent body + 1 corrective `op ⊤ → Opposite.op ⊤` qualification pass), 2 diagnostic checks (1 error → 1 clean), 1 axiom verification (kernel-only), 0 builds, 0 lemma searches.
- **Net diagnostics (review-side re-verification this pass)**: clean (`lean_diagnostic_messages` → `errors: [], warnings: []`, `error_count: 0`, `warning_count: 0` — `attempts_raw.jsonl` log line 15).
- **Axioms on the new theorem (review-side re-verification this pass)**: kernel-only `[propext, Classical.choice, Quot.sound]` (`lean_verify AlgebraicGeometry.Scheme.module_finite_globalSections_of_isProper` — `attempts_raw.jsonl` log line 16).

## Targets attempted (one solved)

### Target — `AlgebraicGeometry.Scheme.module_finite_globalSections_of_isProper`

The geometric Stein input for the iter-043 wholespace H⁰ Hom-finiteness carrier. Provides the algebraic ingredient `Module.Finite k (C.left.presheaf.obj (Opposite.op ⊤))` from `[IsIntegral C.left] [IsProper C.hom]`. The proof bridges Mathlib's `AlgebraicGeometry.finite_appTop_of_universallyClosed` (`Mathlib/AlgebraicGeometry/Morphisms/Proper.lean`, gives `RingHom.Finite (C.hom.appTop.hom)`) to a `Module.Finite` claim via `RingHom.finite_algebraMap` (intermediate algebra) + `Module.Finite.of_equiv_equiv` (transport base from intermediate `Γ(Spec k, ⊤)` to `k` along `Scheme.ΓSpecIso`). The compatibility-of-algebra-maps obligation collapses the trivial restriction `presheaf.map (homOfLE le_top : ⊤ ⟶ ⊤).op` via `Subsingleton.elim` on the `⊤ ⟶ ⊤` hom-set + `Functor.map_id`.

#### Attempt 1 (failed — `op` not in scope)

- **Strategy**: Append the verbatim plan-agent probe-confirmed body inside `namespace AlgebraicGeometry.Scheme`, after iter-043's `module_finite_HModule_zero_of_isHModuleHomFinite_curve` (originally L511) and before `end AlgebraicGeometry.Scheme`. The plan-agent's body used the bare identifier `op ⊤` (6+ occurrences in body type ascriptions plus 1 nested inside an inner `C.left.presheaf.map_id (Opposite.op ...)` call).
- **Code applied** (key fragment):
  ```lean
  theorem module_finite_globalSections_of_isProper
      (k : Type u) [Field k] (C : Over (Spec (CommRingCat.of k)))
      [IsIntegral C.left] [IsProper C.hom] :
      Module.Finite k (C.left.presheaf.obj (op ⊤)) := by
    have hf : (C.hom.appTop.hom).Finite :=
      AlgebraicGeometry.finite_appTop_of_universallyClosed k C.hom
    letI alg2 : Algebra ((Spec (CommRingCat.of k)).presheaf.obj (op ⊤))
                 (C.left.presheaf.obj (op ⊤))
      := RingHom.toAlgebra C.hom.appTop.hom
    -- ... 6 further uses of `op` across the body ...
  ```
- **Lean diagnostic**: `Unknown identifier 'op'` repeated 6+ times starting at L545 col 43 (exact verbatim from `attempts_raw.jsonl` log line 10). The `autoImplicit` is set to `false`, so Lean refuses to bind `op` as an implicit variable.
- **Insight**: The plan-agent's `lean_run_code` probe was self-contained (full preamble) and likely ran with a default `open Opposite` baseline; the file context here lacks that open (file's `open` line at L38 is `open CategoryTheory Limits TopologicalSpace AlgebraicGeometry` — no `Opposite`). All bare `op` references therefore needed to be qualified to `Opposite.op`. **No semantic change** — the fix is purely a name-resolution issue from a probe-vs-file `open`-list mismatch.

#### Attempt 2 (success — single corrective Edit)

- **Strategy**: Re-apply the same body verbatim except qualify every bare `op ⊤` as `Opposite.op ⊤` (6 occurrences in the body type ascriptions + 1 in the inner `C.left.presheaf.map_id (Opposite.op (⊤ : TopologicalSpace.Opens C.left.toTopCat))` argument). No other modifications.
- **Code applied** (key fragments, post-Edit at L542–L578):
  ```lean
  theorem module_finite_globalSections_of_isProper
      (k : Type u) [Field k] (C : Over (Spec (CommRingCat.of k)))
      [IsIntegral C.left] [IsProper C.hom] :
      Module.Finite k (C.left.presheaf.obj (Opposite.op ⊤)) := by
    have hf : (C.hom.appTop.hom).Finite :=
      AlgebraicGeometry.finite_appTop_of_universallyClosed k C.hom
    letI alg2 : Algebra ((Spec (CommRingCat.of k)).presheaf.obj (Opposite.op ⊤))
                 (C.left.presheaf.obj (Opposite.op ⊤))
      := RingHom.toAlgebra C.hom.appTop.hom
    have hM_inter :
        Module.Finite ((Spec (CommRingCat.of k)).presheaf.obj (Opposite.op ⊤))
          (C.left.presheaf.obj (Opposite.op ⊤)) := by
      rw [← RingHom.finite_algebraMap]; exact hf
    refine Module.Finite.of_equiv_equiv
      (Scheme.ΓSpecIso (CommRingCat.of k)).commRingCatIsoToRingEquiv
      (RingEquiv.refl _) ?_
    ext x
    simp only [RingHom.coe_comp, RingEquiv.coe_toRingHom, RingEquiv.refl_apply,
      Function.comp_apply, RingHom.algebraMap_toAlgebra]
    have h_kts : (Scheme.toModuleKSheaf.kToSection C (Opposite.op ⊤)).hom =
                  (C.hom.appTop.hom).comp ((Scheme.ΓSpecIso (CommRingCat.of k)).inv.hom) := by
      ext y
      simp only [Scheme.toModuleKSheaf.kToSection, CommRingCat.hom_comp,
        RingHom.coe_comp, Function.comp_apply]
      exact congrFun (congrArg (·.hom) (C.left.presheaf.map_id (Opposite.op (⊤ :
                  TopologicalSpace.Opens C.left.toTopCat)))) _
    calc (CommRingCat.Hom.hom (Scheme.toModuleKSheaf.kToSection C (Opposite.op ⊤)))
          ((Scheme.ΓSpecIso (CommRingCat.of k)).commRingCatIsoToRingEquiv x)
         = (C.hom.appTop.hom).comp ((Scheme.ΓSpecIso (CommRingCat.of k)).inv.hom)
            ((Scheme.ΓSpecIso (CommRingCat.of k)).commRingCatIsoToRingEquiv x) :=
                congrFun (congrArg DFunLike.coe h_kts) _
      _  = C.hom.appTop.hom x := by
          simp only [RingHom.coe_comp, Function.comp_apply]
          congr 1
          change ((Scheme.ΓSpecIso (CommRingCat.of k)).hom ≫
                (Scheme.ΓSpecIso (CommRingCat.of k)).inv).hom x = x
          rw [Iso.hom_inv_id]; rfl
  ```
- **Lean diagnostic**: clean (`error_count: 0, warning_count: 0` — `attempts_raw.jsonl` log line 15).
- **Verify**: `lean_verify AlgebraicGeometry.Scheme.module_finite_globalSections_of_isProper` returns `{axioms: [propext, Classical.choice, Quot.sound], warnings: []}` — kernel-only (`attempts_raw.jsonl` log line 16).
- **Insight**: Single corrective Edit was purely cosmetic. Body and proof structure unchanged from the plan-agent probe. The corrective is a textbook example of **"probe environment ≠ file environment for `open` lists"** — the probe runs in an isolated module that often has more permissive `open`s than the target file. Going forward, plan-agent probe scaffolds should explicitly mirror the target file's `open` line, OR the prover should pre-emptively expand short names to fully qualified names when grafting a probe body into a file with a known restricted `open` list. Adding a one-liner check to the plan-agent prompt ("after probe-confirmation, scan for short identifiers `op`, `tprod`, etc. that the target file does not `open`") would have caught this in scoping rather than the prover's first Edit.

## Key findings / proof patterns discovered

- **Probe-vs-file `open`-list mismatch as the dominant remaining single-Edit failure mode** (new this iteration): five consecutive zero-corrective-Edit landings (iter-039 → iter-043) had the prover and probe environments aligned by accident; iter-044 surfaces this failure mode for the first time when the probe ran with a default `open Opposite` baseline that the file lacks. The fix is mechanical (qualify all bare `op` to `Opposite.op`) and does not invalidate the body. Reusable: any future probe-confirmed body should be scanned for short names against the target file's `open` line before commit.
- **Stein-finiteness packaging via `finite_appTop_of_universallyClosed` + `RingHom.finite_algebraMap` + `Module.Finite.of_equiv_equiv`** (new this iteration): the canonical Mathlib-backed bridge from "geometrically proper integral $X$ over $\Spec K$" to "$\Gamma(X, \struct X)$ is module-finite over $K$" is a three-stage chain: (1) `finite_appTop_of_universallyClosed` produces `RingHom.Finite (f.appTop.hom)`; (2) `letI` registers the intermediate algebra structure via `RingHom.toAlgebra` and `← RingHom.finite_algebraMap` rewrites to `Module.Finite (intermediate ring) (target ring)`; (3) `Module.Finite.of_equiv_equiv` transports the base ring across `Scheme.ΓSpecIso`. The third stage's compatibility-of-algebra-maps obligation collapses via `Subsingleton.elim` on the trivial `⊤ ⟶ ⊤` hom-set + `Functor.map_id`. **Reusable for any future "proper integral scheme over a base, transport finiteness from intermediate to base"** pattern; the same recipe will recur whenever a `Scheme.foo.appTop.hom`-flavoured `RingHom.Finite` needs to be re-based to the residue field $k$.
- **`Iso.commRingCatIsoToRingEquiv` for transport along `Scheme.ΓSpecIso`** (new this iteration): the canonical adapter `(Scheme.ΓSpecIso _).commRingCatIsoToRingEquiv` is the right shape for the first argument of `Module.Finite.of_equiv_equiv`; the second argument can be `RingEquiv.refl _` because the target ring (`Γ(C, ⊤)`) does not change. Reusable.
- **Calculational `calc` to discharge the algebra-map compatibility goal** (new this iteration): the obligation goal — that two algebra structures coincide on the underlying function — splits as a `calc` chain of two equalities: an `h_kts` rewrite (using `Subsingleton.elim` on `⊤ ⟶ ⊤` + `Functor.map_id`) and a `Iso.hom_inv_id` collapse. Reusable for any future Module.Finite.of_equiv_equiv goal where the algebra structures factor through an iso on the base ring.

## Iter-044 process observations

- **First non-zero-corrective-Edit landing in 6 iterations** (iter-039 → iter-043 were five consecutive zero-corrective-Edit). The single corrective is mechanical and did not require a goal-state probe. The probe-confirmation gate stays load-bearing — the body itself was correct; only the name-resolution context drifted between probe and file.
- **Single-substantive-Edit pattern preserved**: 1 substantive Edit (the verbatim probe body) + 1 cosmetic corrective Edit = 2 Edits total. Below the iter-035 / iter-040 / iter-042 (1-Edit) line but well above the historical multi-Edit floor.
- **Twenty-seventh consecutive substantive single-Edit closure** (counting the substantive content as 1 Edit; the cosmetic name-resolution corrective does not change the body).

## Recommendations for next session

See `recommendations.md`.

## Blueprint markers updated

The iter-044 plan-agent pre-staged the markers correctly in `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex`:

- `Cohomology_StructureSheafModuleK.tex`, `thm:Scheme_module_finite_globalSections_of_isProper`: `\leanok` already present on the statement block at L689 (declaration exists, file compiles, kernel-only axioms).
- `Cohomology_StructureSheafModuleK.tex`, `thm:Scheme_module_finite_globalSections_of_isProper`: `\leanok` already present on the proof block at L702 (no `sorry` in body, no errors, kernel-only axioms — verified review-side via `lean_verify`).
- No `\notready` markers anywhere (sweep clean).
- No `\lean{...}` macro renames flagged in `task_results/StructureSheafModuleK.lean.md` (the prover's adjustment was internal to the body, not a name change).

**No marker edits required this session** — the plan-agent's pre-staging matches the verified state.
