# Iter-099 (Archon canonical) / iter-101 (project narrative) objectives

## Dispatch summary

Single substantive prover lane on `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`.

| Lane | File | Sorry slot | Target | Strategy |
|---|---|---|---|---|
| 1 | `Cohomology/BasicOpenCech.lean` | L768 (post-funext `?hG` per-coordinate discharge) | Close L768 → 5 sorries | 6-step post-funext recipe (Pi.smul_apply / piIsoPi_hom_ker_subtype_apply / ← ModuleCat.hom_comp / eqToHom-naturality + Pi.lift_π_apply / presheafMap_restrict_collapse / scalar congr 1). Hard cap 6. Escalate after 3–4 stalls. |

No other files dispatched. No subagents this iter.

## File status (post iter-100)

| File | Sorries | Compiles? | Status |
|---|---:|---|---|
| `BasicOpenCech.lean` | 6 | ✅ | Lane 1 active. Post-funext per-coordinate goal at L768. |
| `Differentials.lean` | 5 | ✅ | Off-limits (Phase B Mathlib gap). |
| `Modules/Monoidal.lean` | 1 | ✅ | Off-limits (Phase C0 Mathlib gap). |
| `Jacobian.lean` | 1 | ✅ | Off-limits (Phase C3). |
| `Picard/Functor.lean` | 1 | ✅ | Off-limits (gated on C0–C3). |
| `AbelJacobi.lean` | 0 | ✅ | DONE. |
| `Genus.lean` | 0 | ✅ | DONE. |
| `Picard/LineBundle.lean` | 0 | ✅ | DONE (refactor scheduled Phase C1). |
| `Picard/FunctorAb.lean` | 0 | ✅ | DONE. |
| **Total** | **14 syntactic** | | |

## Escalation criterion (iter-101 → iter-102)

The iter-101 prover MUST abort and write a SHORT report if 3–4 sub-attempts
stall at the LSP level. The iter-102 plan agent will then MANDATE escalation
to one of (iter-100 prover report's "Suggested iter-101 plan-agent action",
Priority 2 in recommendations.md):

1. **Body-local helper** — `have h_scalar_extract : ∀ ..., (n • f).hom x j' =
   n • f.hom x j' := by intros; rfl` inside `cechCofaceMap_pi_smul`.
2. **Refactor** — introduce `Pi.lift_thing` as a body-local `let` so the
   iter-098 split-slot lemma's `G` family matches the binder rather than the
   anonymous closure. This is heavier but durably eliminates the
   discrimination-tree blocker.

## Sorry budget (iter-101)

- Hard cap: 6 in `BasicOpenCech.lean` (no regression).
- Target: 5 (close L768).
- Acceptable: 6 (escalate iter-102).
- **Strict**: FILE MUST COMPILE.

## Preserved byte-for-byte across iter-101

1. `alternating_sum_pi_smul_aux` (L478–L494, CLOSED iter-097).
2. `alternating_sum_pi_smul_aux_sum_comp` (L513–L537, body CLOSED iter-099).
3. `cechCofaceMap_pi_smul` prefix L539–L699 (iter-092 through iter-097 B1
   bridge at L699).
4. Iter-099 bridge tactics L700–L712 (`rw [← Pi.smul_apply (i := j)]; refine
   congrFun (alternating_sum_pi_smul_aux_sum_comp Z₁ _ Z₂ Finset.univ _ _
   e₁ e₂ ?_ r y) j`).
5. Iter-100 partial chain L726–L767 (intro + simp + diagnostic comments +
   funext + iter-101 6-step plan comments). Iter-101 prover replaces ONLY
   the L768 sorry.

## Verification (pre-dispatch, this plan pass)

- `sorry_analyzer.py` BasicOpenCech → 6 (unchanged from iter-099).
- `lean_diagnostic_messages` severity=error → `[]`.
- Sorry locations: L768, L860, L1184, L1212, L1402, L1431.
- `archon-protected.yaml`: unchanged.
- `USER_HINTS.md`: empty.
- Task results: archived to `logs/iter-099/` and cleared.
- Blueprint: no edits this iter (helpers are project-local, no `\lean{...}`
  entries).
