# Iter-163 (Archon canonical) — review

## Outcome at a glance
- **The "Route-C foundation laid" iter.** iter-163 was the base-case route DECISION iter (commit
  Route C / Milne §I.3, EXCISE the theorem of the cube). The prover lane then landed the first two
  §I.3 corollaries directly off the proven `rigidity_lemma`: **`hom_additive_decomp_of_rigidity`
  (Cor 1.5)** and **`av_regularMap_isHom_of_zero` (Cor 1.2)**, both sorry-free and axiom-clean
  (`{propext, Classical.choice, Quot.sound}`, re-verified this review — no `sorryAx`).
- **Dispatch MATCHED the plan — 6th consecutive iter** with no plan/dispatch contradiction.
- **Global bare-`sorry` 6 → 6 (unchanged).** Unit of progress is +2 proven theorems (new
  infrastructure), not sorry-elimination. Authoritative inventory: AVR L928/952/981 (the 3 deferred
  genus-0 scaffolds), `Jacobian.lean` L265/L303, `RigidityKbar.lean` L88. No new `axiom`; no
  protected signature touched; `lake env lean AVR.lean` → exit 0.

## The advance, independently verified
1. **`hom_additive_decomp_of_rigidity` (Cor 1.5, L809) — PROVEN, axiom-clean.** Group difference
   `φ := h / ((p≫f)·(q≫g))` in the `GrpObj`-induced hom-group; collapses the complete `V`-axis to
   `1` (= the `_hf` of `rigidity_lemma`); Rigidity factors `φ = q≫g'`; section forces `g'=1`;
   `div_eq_one.mp`. Every value-hypothesis load-bearing.
2. **`av_regularMap_isHom_of_zero` (Cor 1.2, L879) — PROVEN, axiom-clean.** Cor 1.5 applied to
   `h := μ[A]≫α`, `V=W=A`, based at `η[A]`; axis-restrictions reduce to `α` via monoid unit laws;
   packaged as `IsMonHom α`. Carries 3 honest, explicit `A⊗A` variety-instance hyps (Mathlib lacks
   product-instance inference).

## Is this iter-157 laundering again? No.
Both lemmas carry NO `sorryAx`; both review subagents explicitly checked + cleared the iter-157
anti-pattern. Forward-acyclic `\uses`, every hypothesis load-bearing, constructive proofs.

## Review-phase subagents (2 dispatched, both COMPLETE, 0 must-fix)
| Subagent | Slug | mf/maj/min | Headline |
|---|---|---|---|
| `lean-auditor` | iter163 | 0/7/2 | Both new lemmas sound+complete+axiom-clean. 7 majors = stale docstrings (6× now-false "lone residual sorry" on the sorry-free chain; 1× false cube-dependency on `morphism_P1_to_grpScheme_const`). Minors: candidate-unused A-side instances on Cor 1.5; 3 disclosed scaffold sorries. |
| `lean-vs-blueprint-checker` | avr-iter163 | 0/0/2 | Both signatures faithful + axiom-clean; `IsMonHom` accepted rendering; `\uses` forward-acyclic, no laundering. Minors: product-instance hyps unrecorded (`% NOTE:` sufficient — added); uniqueness/W-completeness divergence (Lean more general). Advisory: 3 false downstream proof-block `\leanok` (sync-owned). |
Reports: `logs/iter-163/{lean-auditor-iter163,lean-vs-blueprint-checker-avr-iter163}-report.md`.

## Persistent infra issue surfaced (escalated, not fixable here)
3 downstream proof-block `\leanok` (AVR.tex L903/L960/L1020) are present on `sorry`-bodied targets
→ FALSE → launder the genus-0 headline `thm:rigidity_genus0_curve_to_AV`. Flagged "sync-owned" in
iter-162; STILL persists. No `sync_leanok` artifact under `logs/iter-163/`, no config reference
found. `\leanok` is outside the review agent's domain — escalated to iter-164 plan agent
(recommendations.md CRITICAL): confirm `sync_leanok` runs + strips these; if not, infra bug.

## Actions taken this review
- Added `% NOTE:` to `lem:hom_additivity_over_product` (product `V⊗W` instance hyps +
  existence-only/V-only-complete divergence) and `lem:av_regular_map_is_hom` (pointed `IsMonHom`
  encoding + product `A⊗A` instance hyps). Both checker-confirmed as the proportionate fix.
- Did NOT touch any `\leanok`. Wrote journal (summary/milestones/recommendations), updated
  PROJECT_STATUS.md Knowledge Base, TO_USER.md.

## For the next plan agent (see recommendations.md)
1. CRITICAL: resolve the persistent false `\leanok` / `sync_leanok` question.
2. Next prover frontier: `morphism_Ga_to_av_const` (Prop 3.9 core, reuses the iter-163 hom-group
   idiom) → `rationalMap_to_av_extends` (Thm 3.2, riskiest; mathlib-analogist cross-domain consult
   first).
3. Refresh the 7 stale AVR docstrings as part of the next prover-owned AVR edit.
4. Re-dispatch `progress-critic` (Route C now has 1 iter of trajectory).
