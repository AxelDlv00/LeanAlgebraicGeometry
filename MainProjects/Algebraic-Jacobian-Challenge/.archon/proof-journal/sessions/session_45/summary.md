# Session 45 — iter-045 review

## Metadata

- **Archon iteration**: 045
- **Stage**: prover (Phase A step 6 *Path 2* / Serre-finiteness scaffolding — **global-sections evaluation isomorphism** for the iter-044 geometric Stein input)
- **File touched**: `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` (single file)
- **Sorry count before**: 9 (project-wide non-archon)
- **Sorry count after**: 9 (unchanged — both new bodies probe-confirmed and landed verbatim; no transient scaffold sorries)
- **LOC delta on the touched file**: 615 → 670 (+55) — the iter-045 plan estimate was "+30–45 LOC"; actual +55 (docstrings ~32 lines + bodies ~23 lines). Slightly above the high end of the estimate band, attributable to the explanatory docstrings on both new declarations.
- **Attempts (raw events from `attempts_raw.jsonl`)**: **1 substantive Edit** (single combined Edit appending both declarations verbatim), 1 diagnostic check (clean), 2 axiom verifications (kernel-only on each new declaration), 0 builds, 0 lemma searches, 0 corrective Edits. **Zero-corrective-Edit landing** — the iter-044 retrospective recommendation (probe `open`-list parity check) appears to have been internalised by the iter-045 plan-agent: the iter-045 bodies use `Opposite.op` (qualified) rather than bare `op`, matching the target file's `open` line at L38 (`open CategoryTheory Limits TopologicalSpace AlgebraicGeometry` — no `Opposite`).
- **Net diagnostics (review-side re-verification this pass)**: clean per `attempts_raw.jsonl` log line 8 (`error_count: 0, warning_count: 0`).
- **Axioms on the new declarations (review-side re-verification this pass)**: kernel-only `[propext, Classical.choice, Quot.sound]` on both `AlgebraicGeometry.Scheme.SheafGammaObj_linearEquiv_top` (`attempts_raw.jsonl` log line 9) and `AlgebraicGeometry.Scheme.module_finite_gammaObj_of_isProper` (log line 10).

## Targets attempted (two solved in a single combined Edit)

### Target A — `AlgebraicGeometry.Scheme.SheafGammaObj_linearEquiv_top`

**Step (2) of the iter-044 four-step producer-instance plan.** A `noncomputable def` returning a `LinearEquiv` between the global-sections module `(Sheaf.Γ J _).obj F` (an object of `ModuleCat k`) and the underlying carrier of `F.obj.obj (op ⊤)` for any sheaf `F` on a topological space `X`. The underlying iso comes from Mathlib's `Sheaf.ΓNatIsoSheafSections` (terminal-evaluation natural iso for `Sheaf.Γ`); for the topology of opens, the terminal in `TopologicalSpace.Opens X` is `⊤` via `Preorder.isTerminalTop`. The categorical iso in `ModuleCat k` is converted to a `LinearEquiv` via `Iso.toLinearEquiv`.

#### Attempt 1 (success — first attempt)

- **Strategy**: Append the verbatim plan-agent probe-confirmed body inside `namespace AlgebraicGeometry.Scheme`, after iter-044's `module_finite_globalSections_of_isProper` (currently ending around L578) and before `end AlgebraicGeometry.Scheme` (L580 → L635 post-edit).
- **Code applied** (key body, post-Edit at L597–L603):
  ```lean
  noncomputable def SheafGammaObj_linearEquiv_top
      (k : Type u) [Field k] {X : TopCat.{u}}
      (F : Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} k)) :
      (Sheaf.Γ (Opens.grothendieckTopology X) (ModuleCat.{u} k)).obj F
        ≃ₗ[k] F.obj.obj (Opposite.op (⊤ : TopologicalSpace.Opens X)) :=
    ((Sheaf.ΓNatIsoSheafSections (Opens.grothendieckTopology X)
        (ModuleCat.{u} k) (T := ⊤) (Preorder.isTerminalTop _)).app F).toLinearEquiv
  ```
- **Lean diagnostic**: clean (`error_count: 0, warning_count: 0` per `attempts_raw.jsonl` log line 8).
- **Insight**: A clean three-line term-mode definition. The plan-agent's probe-confirmed body parses against the file's `open` list on first try (the `Opposite` qualification on `op ⊤` matches the file environment). `Sheaf.ΓNatIsoSheafSections` accepts `T := ⊤` and `hT := Preorder.isTerminalTop _` as named arguments cleanly. `.app F` specialises the natural iso to `F`; `.toLinearEquiv` converts the `ModuleCat k`-categorical iso to a `k`-LinearEquiv on carriers — Mathlib's `Iso.toLinearEquiv` is the canonical adapter for this.

### Target B — `AlgebraicGeometry.Scheme.module_finite_gammaObj_of_isProper`

**Immediate consumer** combining iter-044's geometric Stein input with Target A. A `theorem` (NOT `instance`, per plan rationale to avoid silent typeclass-synthesis pollution). Hypotheses: `[IsIntegral C.left] [IsProper C.hom]`. Conclusion: `Module.Finite k` on `(Sheaf.Γ ...).obj (toModuleKSheaf C)` viewed as a `ModuleCat k`.

#### Attempt 1 (success — first attempt)

- **Strategy**: Append the verbatim plan-agent probe-confirmed body in the same Edit as Target A. The `haveI` re-typecasts `Module.Finite k (C.left.presheaf.obj (op ⊤))` (iter-044's conclusion) into `Module.Finite k ((toModuleKSheaf C).obj.obj (op ⊤) : ModuleCat k)` (the LinearEquiv source). Then `Module.Finite.equiv` with `.symm` discharges the goal.
- **Code applied** (key body, post-Edit at L622–L633):
  ```lean
  theorem module_finite_gammaObj_of_isProper
      (k : Type u) [Field k] (C : Over (Spec (CommRingCat.of k)))
      [IsIntegral C.left] [IsProper C.hom] :
      Module.Finite k
        ((Sheaf.Γ (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k)).obj
          (Scheme.toModuleKSheaf C)) := by
    haveI : Module.Finite k
        ((Scheme.toModuleKSheaf C).obj.obj
          (Opposite.op (⊤ : TopologicalSpace.Opens C.left.toTopCat)) : ModuleCat k) :=
      module_finite_globalSections_of_isProper k C
    exact Module.Finite.equiv
      (SheafGammaObj_linearEquiv_top k (Scheme.toModuleKSheaf C)).symm
  ```
- **Lean diagnostic**: clean (`error_count: 0, warning_count: 0` per `attempts_raw.jsonl` log line 8).
- **Insight**: The `haveI` is load-bearing — Lean does not bridge the two spellings of the same module automatically. The two carriers are *the same Module* (via the iter-006 `toModuleKPresheaf_obj` simp lemma) but Lean needs the explicit typeclass registration under the new spelling. After the `haveI`, `Module.Finite.equiv` chains the iter-044 finiteness through the iter-045 LinearEquiv (`.symm` orientation: source `Γ(C.left, ⊤)`, target `(Sheaf.Γ).obj (toModuleKSheaf C)`).

## Key findings / proof patterns reinforced

- **Two-declaration package, single combined Edit** *(iter-045, mirrors iter-038/039/040/041)*: when a building-block `LinearEquiv` plus its immediate consumer both have probe-confirmed bodies, they can be packaged into one Edit. Reduces churn and keeps the diff atomic.
- **`.toLinearEquiv` on a `ModuleCat k` categorical iso** *(iter-045, new this iteration)*: the canonical Mathlib adapter for converting an iso in `ModuleCat k` to a `≃ₗ[k]` on the carriers. Reusable for any future "categorical iso → LinearEquiv" pattern in `ModuleCat k`-valued sheaf computations.
- **`Sheaf.ΓNatIsoSheafSections` + `Preorder.isTerminalTop`** *(iter-045, new this iteration)*: the canonical two-step ladder for "global sections of a sheaf on `Opens X` = evaluation at `⊤`". The `(T := ⊤)` named argument and `Preorder.isTerminalTop _` discharge the terminal data in one line. Reusable for any future evaluation-at-terminal computation on the topology of opens.
- **`haveI` re-spelling for typeclass auto-synthesis bridge** *(iter-045, mirrors iter-006/038)*: when two module structures coincide on the carrier (via a simp-lemma identification) but Lean does not auto-bridge them, `haveI : Module.Finite k (target_spelling) := source_evidence` is the cheapest fix. Avoids spelling out a `LinearEquiv` for the trivial identification.
- **`Module.Finite.equiv ... .symm` orientation pattern** *(iter-045, mirrors iter-037/038)*: when the source `LinearEquiv` orientation does not match the target `Module.Finite` direction, `.symm` flips it in one token. Cheaper than constructing the reversed equivalence directly.
- **Probe `open`-list parity check honoured** *(iter-045, response to iter-044 retro)*: the iter-045 plan-agent appears to have applied the iter-044 retrospective recommendation — the bodies use fully qualified `Opposite.op` rather than bare `op`, matching the target file's `open` line. **First post-recommendation iteration confirms the discipline holds.** Result: zero-corrective-Edit landing.
- **Verbatim probe-confirmed body landing pattern continues** *(iter-035 → iter-045)*: 9 of 11 iterations zero-corrective-Edit, 1 with 1 cosmetic corrective (iter-044), 1 with 1 substantive corrective on a non-Edit-bound issue. The pattern of "plan-agent probe-confirms, prover lands verbatim" is firmly established.

## Blueprint markers updated

The iter-045 plan-agent already pre-marked both new theorems' statement and proof blocks with `\leanok` in `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex` § *Global-sections evaluation isomorphism (iter-045)* (Theorems `thm:Scheme_SheafGammaObj_linearEquiv_top` and `thm:Scheme_module_finite_gammaObj_of_isProper`, plus `\leanok` on both proof blocks at L726/738/742/755).

This pass — review-side re-verification of compilation (clean diagnostics) and axioms (kernel-only on both) confirms the pre-marks are valid:
- `Cohomology_StructureSheafModuleK.tex`, `thm:Scheme_SheafGammaObj_linearEquiv_top`: pre-marked `\leanok` on statement (L726) — **verified valid this pass**.
- `Cohomology_StructureSheafModuleK.tex`, `thm:Scheme_SheafGammaObj_linearEquiv_top`: pre-marked `\leanok` on proof (L738) — **verified valid this pass** (kernel-only axioms, no sorry).
- `Cohomology_StructureSheafModuleK.tex`, `thm:Scheme_module_finite_gammaObj_of_isProper`: pre-marked `\leanok` on statement (L742) — **verified valid this pass**.
- `Cohomology_StructureSheafModuleK.tex`, `thm:Scheme_module_finite_gammaObj_of_isProper`: pre-marked `\leanok` on proof (L755) — **verified valid this pass** (kernel-only axioms, no sorry).

No marker edits required from the review agent this iteration — pre-marks are accurate. `blueprint/lean_decls` already contains both new entries (L37: `AlgebraicGeometry.Scheme.SheafGammaObj_linearEquiv_top`; L38: `AlgebraicGeometry.Scheme.module_finite_gammaObj_of_isProper`).

## Recommendations for next session (iter-046)

See `recommendations.md`. Highest-priority track: **Step (1) of the iter-044 four-step plan** — the linearised constant-sheaf-Γ adjunction `homEquiv` (project-local lift of Mathlib's `Adjunction.homAddEquiv` to `≃ₗ[k]`). This is the substantive multi-iteration step; the plan-agent should re-probe Mathlib HEAD for any pre-existing linearised lift before committing to the project-local construction.
