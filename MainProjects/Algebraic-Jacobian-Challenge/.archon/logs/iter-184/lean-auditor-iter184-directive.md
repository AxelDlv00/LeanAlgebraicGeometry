## Files to audit

Focus on these four `.lean` files modified during iter-184 prover phase:

- `AlgebraicJacobian/AbelianVarietyRigidity.lean` — Lane E: closed `iotaGm_onePt_chart1_factor` (L105) Tier-1 axiom-clean.
- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` — Lane G: closed both inductive-step residuals of `depth_eq_smallest_ext_index` Tier-1 axiom-clean.
- `AlgebraicJacobian/Albanese/CodimOneExtension.lean` — Lane M↓: replaced bare `hreg_dim` sorry with structured `refine ⟨?_, ?_⟩` proof — Krull-dim half closed, `IsRegularLocalRing` half remains as typed sorry (Stacks 00TT gap). Added `import AlgebraicJacobian.Albanese.CoheightBridge`.
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` — Lane B: added two `@[reassoc (attr := simp)]` helpers `pullback_map_fst_proj` / `pullback_map_snd_proj` near the top of the file. Lane terminated due to weekly limit BEFORE attempting Recipe 2/3 cocycle closure.

## What I expect from you

Per-file checklist of:
- Outdated comments (especially any iter-NNN annotations now wrong).
- Suspect definitions (especially any new typed-sorry pattern or laundering shape).
- Dead-end proofs (any `sorry`-bodied helper whose use site never consumes it).
- Bad Lean practices (`set` vs `change`, `show` linter warnings, unnecessary `have`, etc.).
- Critical pushback on excuse-comments / hand-waving in proof bodies.

Also verify the four Tier-1 axiom-clean claims via `lean_verify` on:
- `AlgebraicGeometry.iotaGm_onePt_chart1_factor`
- `RingTheory.Module.depth_eq_smallest_ext_index`
- `AlgebraicGeometry.pullback_map_fst_proj`
- `AlgebraicGeometry.pullback_map_snd_proj`

Each should resolve to `{propext, Classical.choice, Quot.sound}` only (no `sorryAx`).

Pay extra attention to the GmScaling new helpers — they were added but their use site (Recipe 2/3 lemmas + cocycle body) was NOT landed due to the prover session terminating mid-flight. Confirm they are not orphan dead-code stubs (i.e. that they at least compile and have honest content; they are intended for next-iter use).

## Out of scope

Do NOT audit the other 6 lane files (QuotScheme, RelativeSpec, OCofP, OcOfD, RRFormula, RationalCurveIso) — their prover sessions hit the weekly API limit at first turn and committed no edits.

## Report length

Under ~400 lines. Concrete findings only.
