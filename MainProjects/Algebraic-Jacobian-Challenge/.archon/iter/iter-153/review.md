# Iter-153 (Archon canonical) — review

## Outcome at a glance

- **Single prover lane FIRED** on `Cotangent/ChartAlgebra.lean` — the
  iter-152 `[IsAlgClosed]` pivot-validation lane. `meta.json`:
  `planValidate.status: ok / objectives: 1`, `prover.status: done`,
  `prover.durationSecs: 471` (~7.9 min).

- **FIRST NET SORRY REDUCTION SINCE THE PIVOT: 9 → 8.**
  `constants_integral_over_base_field` **CLOSED** — and verified
  **axiom-clean** this review (`lean_verify
  AlgebraicGeometry.constants_integral_over_base_field` →
  `{propext, Classical.choice, Quot.sound}`, **no `sorryAx`**). This is a
  genuine closure, not a laundered or placeholder one.

- **Per-file sorry tally at iter-153 close** (re-verified):
  - `Cotangent/ChartAlgebra.lean` — **1** (was 2): KDM L270, sorry-site
    L427.
  - `Cotangent/ChartAlgebraS3.lean` — 4 (off-path): L199, L276, L342, L403.
  - `Cotangent/GrpObj.lean` — 0.
  - `Jacobian.lean` — 2: L197, L223.
  - `RigidityKbar.lean` — 1: L88.
  - Total: **8**.

- **Prover activity** (`attempts_raw.jsonl`): 5 edits, 0 goal checks, 5
  diagnostic checks, 0 builds, 7 lemma searches. No protected-signature
  change; no new axioms; all edits outside the constants proof body are
  comment/docstring-only.

## The closure (headline)

`constants_integral_over_base_field` closed in ~25–30 LOC via the iter-152
alg-closed three-step collapse (full proof structure in
`proof-journal/sessions/session_153/summary.md` and the new KB Proof
Pattern entry). The load-bearing reusable move is the iso-transfer
`RingHom.finite_respectsIso.2 (e := (ΓSpecIso _).symm.commRingCatIsoToRingEquiv)`
— the exact analogue of the `isIntegral_respectsIso.2` step inside
Mathlib's own `isField_of_universallyClosed`. Under `[IsAlgClosed k]` the
entire (S3.sep/pi) separability/inseparability detour is gone.

**Significance:** this is the prover validation the iter-152 plan promised
("GUARANTEED 9→8") and the discharge of the iter-152 progress-critic's
standing must-fix ("a prover MUST validate the corrected signatures by
iter-154"). The architectural pivot is now backed by a real closed lemma,
not just a green build.

## The bright-line stop (KDM)

`mem_range_algebraMap_of_D_eq_zero` retains its single open `sorry`
(L427). The prover correctly honoured the STRATEGY.md bright-line: one
search round, no code churn, no new helper layer, no re-decomposition.
The residual content is blueprint step **FT.3** — `ker (KaehlerDifferential.D
k K)` = relative algebraic closure of `k` for a separably generated char-0
field extension `K = Frac B / k`. Confirmed a genuine Mathlib gap
(b80f227) by a documented negative search (full enumeration in the KB
Known-Blocker update and the in-Lean note L398–426). **Next move is a
`mathlib-analogist` cross-domain consult, NOT another prover round.**

## Review-phase subagents (2 dispatched)

| Subagent | Slug | Verdict | Key findings |
|---|---|---|---|
| `lean-vs-blueprint-checker` | chartalgebra-iter153 | **PASS** — 0 must-fix / 0 major | Both directive lemmas match their `RigidityKbar.tex` blocks bidirectionally (signatures, hypotheses, proof structure). `constants_integral` verified axiom-clean with correct `\leanok`; KDM's open FT.3 `sorry` faithfully reflected (statement-block `\leanok`, no proof-block `\leanok`), hypotheses `[IsAlgClosed k]`+`[IsDomain B]`+`[CharZero k]` agree class-for-class. 2 minor housekeeping (superseded (p1)/(p2)/(BR.*) prose now buries the ~5-line live FT route; dead `_hFree`/`_basis` Lean scaffolding). |
| `lean-auditor` | iter153 | **0 must-fix / 6 major / 6 minor** | Confirms `constants_integral` genuinely `sorryAx`-free and KDM is the file's only open sorry. Majors are all post-pivot hygiene/orphaning: (1) KDM body's ~95 lines of inert scaffolding around a bare `sorry`; (2) KDM body carries two conflicting closure narratives (iter-150 MvPolynomial vs iter-153 FT.3) — the "remains reusable" claim is inconsistent with the FT route; (3) `df_zero` sorryAx-laundered with no warning + header silent on "unproven pending KDM"; (4) **`ChartAlgebraS3.lean` entirely orphaned** post-pivot (nothing consumes it); (5) stale ChartAlgebraS3 consumer-integration claims; (6) stale `Jacobian.lean` header inventory. None block proving. Folded into `recommendations.md` §2–§3. |

Reports: `task_results/lean-vs-blueprint-checker-chartalgebra-iter153.md`,
`task_results/lean-auditor-iter153.md`.

## Blueprint doctor (iter-153)

Clean: every chapter `\input`'d, every `\ref`/`\uses` resolves, every
annotation non-empty, no `axiom` declarations.

## Persistent soundness note (carried, unchanged this iter)

`df_zero_factors_through_constant_on_chart` (L455) remains a one-line
delegate to KDM: its own body is sorry-free but it carries `sorryAx`
transitively (honest open obligation, not a false-lemma laundering — the
character changed at iter-152). The same holds for `nonempty_jacobianWitness`
(Jacobian.lean). The warning-based "8 sorries" headline therefore still
undercounts the transitively-incomplete surface — unchanged from iter-152;
recorded for the plan agent.
