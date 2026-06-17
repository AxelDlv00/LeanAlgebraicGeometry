# Progress-critic directive — iter-073

Assess convergence of the SINGLE active route. Verdict per route.

## Route: Sub-brick A / `CechSectionIdentification.lean` (CSI) — P5a-resolution input

STRATEGY estimate for this phase: `Iters left ~1–3`. Phase entered its current
("coreIso_comm chain") sub-state at iter-072; the broader P5a-resolution phase has been
ACTIVE/OVER_BUDGET (~15 informative iters; iters 068–071 were infrastructure outages with
ZERO prover signal — exclude them from churn assessment).

### Per-iter signals (CSI), K=last informative iters

- **iter-067:** sorry 3→2. Closed `coverInterOpen_inf_eq_iInf_inf`, `coreIso_objIso`, `hcompat`
  (via canonical `sectionCechAugV`). The 2 residual sorries WERE: `coreIso_comm` (whole
  differential-match square) + `cechSection_contractible` (whole augmented contracting homotopy).
  Status: PARTIAL (real closes).
- **iter-068–071:** NO prover work — sessions killed mid-wave (infrastructure casualties). No
  helpers, no signal. Exclude.
- **iter-072:** sorry 2→2 by COUNT, but the residual CHANGED. The whole `coreIso_comm` chain was
  PROVED: `coreIso_comm_coface`, `coreIso_comm_sum`, `coreIso_comm` (rewired). Stub 6
  `cechSection_contractible` FULLY ASSEMBLED: the dependent combinatorial engine
  (`cechSectionCoeff/Coface/Prepend`, `hu`/`hsh`) proved, the (I0)/(I1)/(In) contracting identities
  proved, `Homotopy.mkCoinductive` wrapped (`cechSection_succ_step` proved). The seam
  `pushPull_sigma_iso_π` PROVED. Helpers added: ~20 (the Stub6 engine + the chain). Residual = TWO
  ATOMIC GEOMETRIC LEAVES: `coreIso_comm_leg` (per-leg naturality) + `sectionCechAugV_π` (degree-0
  augmentation seam). Both reduce to the already-PROVED `pushPull_sigma_iso_π` + `pushPull_leg_sections`.
  Status: PARTIAL (large composite goals replaced by two atomic leaves; everything else proved).

Recurring blocker phrase: `Preadditive.comp_sum`/`Functor.map_sum` clash with the bundled
`AddCommGrpCat`-hom `objD` ⇒ proofs must go ELEMENTWISE (recorded, route-stable).

### This iter's planned objective (for dispatch-sanity)
ONE prover lane: CSI, `prove` mode — close `coreIso_comm_leg` (1536) and `sectionCechAugV_π` (2081),
the two atomic leaves. No new helpers planned; both target the proved-seam unwinding.

## Question for you
Is CSI CONVERGING or CHURNING? Specifically: the sorry COUNT was flat (2→2) iter-067→072, but the
RESIDUAL shrank from two whole composite goals to two atomic leaves with all scaffolding proved. Is
that genuine structural advance (CONVERGING) or helper-churn around an unmoving core (CHURNING)? If
CHURNING/STUCK, name the corrective TYPE.
