# Session 40 — iter-040 review

## Metadata

- **Archon iteration**: 040
- **Stage**: prover (Phase A step 6 *Path 2* / Serre-finiteness scaffolding — affine cohomology vanishing carrier predicate + immediate `Module.Finite` consumer)
- **File touched**: `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` (single file)
- **Sorry count before**: 9 (project-wide non-archon, per `sorry_analyzer.py`)
- **Sorry count after**: 9 (unchanged — both bodies are probe-confirmed; sorry trajectory `9 → 9 → 9`)
- **LOC delta on the touched file**: +39 (per `wc -l`: 381 → 420 in the current snapshot — task result claimed +43; minor accounting slack from blank lines / final newline). Inside the plan estimate ("+~25 LOC append" plus full docstrings).
- **Attempts (raw events from `attempts_raw.jsonl`)**: 1 substantive Edit (single combined append of both declarations), 1 diagnostic check, 2 axiom verifications (zero builds, zero searches, zero corrective Edits).
- **Net diagnostics**: clean (`{success: true, items: [], failed_dependencies: []}` → `error_count: 0, warning_count: 0`).
- **Axioms on both new declarations**: kernel-only `[propext, Classical.choice, Quot.sound]`.

## Targets attempted (both solved)

### Target 1 — `AlgebraicGeometry.Scheme.IsAffineHModuleVanishing`

Carrier predicate (single-field `class`) packaging Serre-affine-vanishing for the `ModuleCat k`-flavoured cohomology as a hypothesis. Mathlib gap re-probed this pass: still absent — only abstract `subsingleton_H_of_isZero` available, trivial.

#### Attempt 1 (success — verbatim probe-confirmed body, single combined Edit)

- **Strategy**: append the verbatim PROGRESS.md probe-confirmed body inside `namespace AlgebraicGeometry.Scheme`, between iter-039's `module_finite_HModule'_zero_curve` (ending L344) and `end AlgebraicGeometry.Scheme` (was L346). Short name written **without** the `Scheme.` prefix per known-dead-end #185 (already internalised by the iter-039 plan-agent prompt).
- **Code applied** (key fragment, L355–L361 in the post-Edit file):
  ```lean
  class IsAffineHModuleVanishing
      (k : Type u) [Field k] (C : Over (Spec (CommRingCat.of k)))
      (F : Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k)) :
      Prop where
    subsingleton_HModule' : ∀ {U : TopologicalSpace.Opens C.left.toTopCat},
      AlgebraicGeometry.IsAffineOpen U → ∀ i, 0 < i →
        Subsingleton (Scheme.HModule' k F i U)
  ```
- **Goal before / after**: n/a — this is a `class` declaration, not a tactic-mode proof. (No goal state was checked because the prover applied the verbatim probe-confirmed body in a single Edit.)
- **Lean diagnostic** (post-Edit, joint with Target 2): clean (`error_count: 0`, `warning_count: 0`).
- **Verify**: `lean_verify AlgebraicGeometry.Scheme.IsAffineHModuleVanishing` returns `{axioms: [propext, Classical.choice, Quot.sound], warnings: []}`.
- **Insight**: zero-corrective-Edit landing — second consecutive iteration (iter-039, now iter-040). The `Subsingleton` formulation (rather than `Limits.IsZero`) is mandated by the iter-014 typing — `HModule'` returns a `Type u`, not a `ModuleCat` object — so categorical `IsZero` does not directly apply, but `Subsingleton` is more directly chainable into `Module.Finite` via instance synthesis (used by Target 2). Pattern reusable: any future `Subsingleton`-flavoured affine-vanishing carrier predicate for a `Type u`-valued cohomology gadget (e.g. derived-functor/Ext-evaluated) should follow this template.

### Target 2 — `AlgebraicGeometry.Scheme.module_finite_HModule'_of_isAffineHModuleVanishing`

Immediate consumer of Target 1: given the class hypothesis, the open-evaluation cohomology `HModule' k F i U` is `Module.Finite k` for any affine open `U` and any `i > 0`.

#### Attempt 1 (success — verbatim probe-confirmed body, single combined Edit with Target 1)

- **Strategy**: appended in the same Edit as Target 1; class hypothesis `[IsAffineHModuleVanishing k C F]` activated; explicit args `(hU : IsAffineOpen U) (i : ℕ) (hi : 0 < i)` chosen because `hU` and `hi` cannot be instance-synthesised (would prevent typeclass resolution from firing). `theorem` (not `instance`) because of the explicit `hU`/`hi` blockers.
- **Code applied** (key fragment, L374–L383 in the post-Edit file):
  ```lean
  theorem module_finite_HModule'_of_isAffineHModuleVanishing
      (k : Type u) [Field k] (C : Over (Spec (CommRingCat.of k)))
      (F : Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k))
      [IsAffineHModuleVanishing k C F]
      {U : TopologicalSpace.Opens C.left.toTopCat}
      (hU : AlgebraicGeometry.IsAffineOpen U) (i : ℕ) (hi : 0 < i) :
      Module.Finite k (Scheme.HModule' k F i U) :=
    have : Subsingleton (Scheme.HModule' k F i U) :=
      IsAffineHModuleVanishing.subsingleton_HModule' (F := F) hU i hi
    inferInstance
  ```
- **Goal before / after**: implicit — the `have` extracts the class field as a `Subsingleton`, then `inferInstance` invokes Mathlib's auto-derived `Subsingleton M → Module.Finite R M` instance (any subsingleton module is generated by the empty set, hence finitely generated and finitely presented).
- **Lean diagnostic** (post-Edit, joint with Target 1): clean.
- **Verify**: `lean_verify AlgebraicGeometry.Scheme.module_finite_HModule'_of_isAffineHModuleVanishing` returns `{axioms: [propext, Classical.choice, Quot.sound], warnings: []}`.
- **Insight**: parallel zero-corrective-Edit landing. The two-line body (`have ... inferInstance`) is the cleanest possible consumer — no rewriting, no induction, no `apply` chains. This works **only** because Mathlib auto-derives `Module.Finite` from `Subsingleton`; if this instance were ever weakened (e.g. requiring `DecidableEq R`), the body would need to switch to a manual `⟨⟨∅, by simp⟩⟩` construction. Pattern reusable: any "carrier predicate ⇒ `Module.Finite`" wrapper for a `Subsingleton`-flavoured class field can use the exact same `have ... inferInstance` recipe.

## Key findings / proof patterns

- **Pattern (re-confirmed)** — verbatim probe-confirmed body, single combined Edit (iter-040, mirrors iter-035 / iter-036 / iter-037 / iter-039): when the plan-agent's `lean_run_code` probe returns `{success: true, diagnostics: []}` end-to-end on the proposed body, the prover lands the body verbatim in a single Edit with zero corrective rounds. **Now 5 of 6 iterations zero-corrective-Edit (iter-035, iter-036, iter-037, iter-039, iter-040), 1 of 6 with two corrective Edits sharing one root cause (iter-038 / known-dead-end #185, since internalised).** The probe-confirmation gate has been the dominant predictor of zero-corrective-Edit landings across the cohort.
- **Pattern (new, not previously surfaced)** — *carrier-predicate + immediate consumer* paired-cohort packaging (iter-040): the carrier `class` and its immediate `Module.Finite` consumer were paired in a single iteration, not split across iter-040 (carrier) + iter-041 (consumer). This is a deviation from the `_abstract` + `_curve` paired-cohort pattern (iter-035 → iter-039) — the carrier and consumer here are independent of curve-specialisation; both are formulated in terms of an arbitrary sheaf `F`. **Forward implication**: the producer instance `IsAffineOpen U → IsAffineHModuleVanishing k C (toModuleKSheaf C)` (queued for iter-041+) can specialise to `F := toModuleKSheaf C` independently of the carrier/consumer pair; the consumer is already curve-ready by parametrisation. This is preferable to introducing a `_curve` companion of the consumer, which would just be a partial instance application.
- **Pattern (re-confirmed)** — `Subsingleton` formulation over `Limits.IsZero` for `Type u`-valued cohomology gadgets (iter-040): when a project carrier predicate must talk about a `Type u`-flavoured cohomology (here `HModule' k F i U`, returning a `Type u` rather than a `ModuleCat` object — see iter-014 `def` choice), `Subsingleton` is the right Mathlib idiom: it directly chains into `Module.Finite` via instance synthesis. Categorical `IsZero` would force a roundtrip through `ModuleCat.subsingleton_of_isZero`. Reusable for any future `Type u`-valued cohomology carrier.
- **Pattern (re-confirmed)** — `class` + `theorem` over `class` + `instance` when explicit hypothesis args block typeclass resolution (iter-040): the consumer's `(hU : IsAffineOpen U)` and `(hi : 0 < i)` arguments cannot be instance-synthesised, so the consumer is a `theorem` (not an `instance`). Reusable for any future "carrier ⇒ structural property" wrapper that needs explicit witnesses.
- **Sixth consecutive substantive single-Edit closure (Edit-count 1)**: the cohort is now 23 consecutive single-Edit closures since iter-018 (Edit-count 1 substantive across all of iter-018 → iter-040). Net: the probe-confirm-then-land protocol is robust.

## Blueprint markers updated

The plan-agent had already pre-staged all four `\leanok` markers in the chapter (statement and proof blocks) for both new theorems before the prover ran (lines 494, 503, 507, 517 of `Cohomology_StructureSheafModuleK.tex`). All four markers verified accurate post-prover:

- `Cohomology_StructureSheafModuleK.tex`, `thm:Scheme_IsAffineHModuleVanishing` (statement, L494): confirmed `\leanok` on statement (declaration `AlgebraicGeometry.Scheme.IsAffineHModuleVanishing` exists at the new declaration site L355–361, file compiles).
- `Cohomology_StructureSheafModuleK.tex`, `thm:Scheme_IsAffineHModuleVanishing` (proof block, L502–L505): confirmed `\leanok` on proof (no `sorry`, no errors, kernel-only axioms via `lean_verify`; the "proof" here is definitional — the `class` declaration itself is the content).
- `Cohomology_StructureSheafModuleK.tex`, `thm:Scheme_module_finite_HModule_prime_of_isAffineHModuleVanishing` (statement, L507): confirmed `\leanok` on statement (declaration `AlgebraicGeometry.Scheme.module_finite_HModule'_of_isAffineHModuleVanishing` exists at L374–383, file compiles).
- `Cohomology_StructureSheafModuleK.tex`, `thm:Scheme_module_finite_HModule_prime_of_isAffineHModuleVanishing` (proof block, L515–L518): confirmed `\leanok` on proof (no `sorry`, no errors, kernel-only axioms via `lean_verify`).

No `\lean{...}` macro renames required (both names match PROGRESS.md verbatim short-name dictionary, qualified blueprint references are correct). No stale `\notready` markers found. No `% NOTE:` annotations required.

## `blueprint/lean_decls` drift — caught up this iteration

For the **first time in seven iterations**, the iter-040 plan-agent appended **the iter-040 declarations themselves** to `blueprint/lean_decls` in the same pass that introduced them (rather than the now-customary clear-on-arrival in the next iteration's plan-agent pass). New entries at L27–28:

- `AlgebraicGeometry.Scheme.IsAffineHModuleVanishing`
- `AlgebraicGeometry.Scheme.module_finite_HModule'_of_isAffineHModuleVanishing`

Combined with the iter-039 entries already present at L25–26 (caught up by the iter-040 plan-agent earlier in the pass), `blueprint/lean_decls` is now **fully current through iter-040**. **First clear-as-you-go iteration since iter-033**. Recommendation in `recommendations.md` is therefore *softened* — the manual escalation to a hook may no longer be needed if the iter-041 plan-agent maintains the discipline.
