# Strategy Critic Directive — iter-151

Fresh-eyes critique of the project strategy. Read ONLY the files/inputs named
below. Do NOT read `PROGRESS.md`, any `iter/iter-NNN/` sidecar,
`task_pending.md`, `task_done.md`, prover task results, or review reports —
your value is a view uncontaminated by the project's recent momentum.

## Read these
1. `.archon/STRATEGY.md` (verbatim — the current strategy; just edited this iter).
2. `references/summary.md` (the reference index).

## Project goal (one paragraph)
Formalize Christian Merten's Jacobian challenge: nine protected Lean
declarations headlined by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — the existence of an Albanese/Jacobian
object uniform over the k-rational pointing of a smooth proper geometrically
irreducible curve `C/k`, with NO `C(k) ≠ ∅` hypothesis on the protected
signature. End-state: zero inline `sorry`, kernel-only axioms.

## Blueprint chapters (titles + one-line topic; do not read them in full)
- `Jacobian.tex` — Albanese/Jacobian existence; Route A (Picard scheme via FGA).
- `RigidityKbar.tex` — rigidity over k̄ + the chart-algebra (Route C) piece (ii) decomposition.
- `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` — the four (S3.*) sub-claims.
- `AlgebraicJacobian_Cotangent_GrpObj.tex` — cotangent-space-at-identity trio.
- `Differentials.tex` — smooth ⇒ Ω locally free (forward Jacobian criterion).
- `Genus.tex` — genus definition.
- `Rigidity.tex` — scheme-level rigidity packaging.
- `AbelJacobi.tex` — Abel–Jacobi projection from Albanese.
- `Cohomology_*.tex` — Mayer–Vietoris / structure-sheaf cohomology infrastructure.

## What changed this iter (so you can focus your re-verification)
- **Route A re-scoped** per a first-hand read of `references/kleiman-picard.pdf`:
  midpoint ~6070 → ~5100 LOC; finding recorded that the existence engine (A1,
  Quot/Hilbert via Nitsure) is irreducible while A2/A3 (identity-component +
  curve finiteness) shrink. Challenge this if the LOC logic or the
  "irreducible engine" claim looks wrong.
- **Route C bright-line** added (no further sorry-count-inflating
  decomposition; the bounded KDM transfer-step close-out is the only sanctioned
  next prover step; failure → STUCK → pivot/escalate).
- A user-input decision request folded into Open questions (`[IsAlgClosed kbar]`
  + build/axiomatize/re-route for the flat-base-change-of-Γ gap).

## Deliver
Per-claim verdict (SOUND / CHALLENGE / REJECT) on the strategy as it stands,
with specific attention to: (a) is the Route-A re-scope honest and is ~5100
defensible; (b) is the genus-0-critical-path / positive-genus-off-critical-path
split still the right spine; (c) any DRIFT (per-iter narrative leaking into the
stable-end-state document). For any CHALLENGE, name the concrete strategy edit
you'd want.
