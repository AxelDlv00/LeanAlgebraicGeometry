# iter-076 recommendations

## Headline
- `hSec` / `cechSection_isZero_homology` CLOSED → `cechAugmented_exact` (P5a-resolution) is now
  literal-sorry-free. Project drops to **ONE** remaining inline sorry: the frozen P5b assembly
  `cech_computes_higherDirectImage` at `CechHigherDirectImage.lean:780`.
- The prover landed the edit **unverified** (every prover `lake build` exit 137 — see Build wall).
  The review agent rebuilt it from a 512 GiB cap and it is **GREEN (exit 0)** — the close is
  kernel-sound, not just LSP-clean.

## Build wall (must address before next heavy lane)
- The prover sandbox is memory-cgroup-capped well below the host (host: 1 TiB free, review-agent
  cgroup: 512 GiB). `CechAugmentedResolution.lean` imports the full CSI chain + CechHigherDirectImage
  + AffineSerreVanishing + QcohTildeSections; building it from cold OOM-kills the prover (exit 137),
  so the prover could not verify its own edit. This is the iter-073 wall recurring on the heaviest
  downstream module.
- **Action for the planner:** when a lane targets a module whose cold-build OOMs the prover, EITHER
  (a) pre-warm `.olean`s for its import closure in a prior step (the deps were already green this iter
  — only the leaf module needed compiling), OR (b) raise the prover memory cap, OR (c) sanction
  LSP-mode proving on that module with `sync_leanok` / a review-agent build as the verification gate
  (as iter-074 did via the file split). Do NOT bare-re-dispatch a prover at a cold-OOM module.

## Next lane (P5b — now unblocked)
- `cech_computes_higherDirectImage` (CHDI:780, protected/frozen signature, Route-A acyclic-resolution
  assembly) is the last project sorry. Its `\uses` closure (`cechAugmented_exact`,
  `rightDerivedIsoOfAcyclicResolution`, `cech_term_pushforward_acyclic`,
  `acyclic_resolution_computes_derived`) is now all in place. Per the planner's standing note, P5b also
  wants a ~6-LOC `EnoughInjectives X.Modules` connector (`InjectiveResolution.instMonoFNatι`) built at
  assembly — see ARCHON_MEMORY. These two are parallelisable next iter.
- HARD GATE: confirm the blueprint chapter for `cech_computes_higherDirectImage` (Route-A reduce-to-
  affine sketch) is `complete+correct` before dispatch; gate076 marked
  `Cohomology_HigherDirectImage.tex` complete+correct, so the gate is likely already satisfied — re-run
  the blueprint-reviewer next plan phase to confirm.

## Hygiene (non-blocking, for a cleanup pass)
- Stale docstrings claim a sorry that no longer exists:
  - `CechSectionIdentification.lean:20` — "`sorryAx`-tainted only through the upstream
    `coreIso_comm_leg` sorry" — `coreIso_comm_leg` is now 0-sorry (closed iter-075 via
    `pushPull_interLegHom_sections`).
  - `CechSectionIdentificationLeg.lean:15` — "Carries the residual sorry `coreIso_comm_leg`." Same.
  These are .lean comments (review agent does not edit .lean); flag to a prover/refactor lane to strip.
- `CechSectionIdentificationBase.lean` carries style-linter warnings (long lines @1182/1191/1219/1389,
  uncommented `set_option synthInstance.maxHeartbeats 800000` @1233). Cosmetic; low priority.

## Coverage / DAG
- `archon dag-query unmatched` = 0 (covdebt076 cleared 41 helpers into 7 parent `\lean{}` lists).
- `archon dag-query gaps` = 0 (no ∞ holes). The new `cechSection_isZero_homology` is blueprinted
  (`lem:cechSection_isZero_homology`, 9491) with correct `\uses`. No coverage debt introduced this iter.

## Do NOT
- Do NOT re-assign `hSec` — it is closed and review-build-verified.
- Do NOT dispatch a prover at CHDI:780 from a cold build inside the prover cap without first
  pre-warming oleans or raising the cap — it will hit the same exit-137 wall as this iter.
