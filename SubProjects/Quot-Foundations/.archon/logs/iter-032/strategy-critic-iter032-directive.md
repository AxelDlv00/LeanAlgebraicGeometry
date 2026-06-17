# Strategy-critic directive — iter-032

Audit the project strategy as a fresh mathematician. STRATEGY.md changed this iter: GR-glue and QUOT
gap1 bridge C moved to Completed; FBC-A risk note rewritten around a declaration-ordering root-cause;
QUOT P1 marked unblocked. Confirm the strategy these changes serve is sound.

## Project goal

Close the `sorry`-bearing nodes of the **Čech-independent leg** of the parent's
`thm:fga_pic_representability` cone (Kleiman FGA, "The Picard scheme", §4): flat base change for the
i=0 pushforward (FBC), generic flatness (GF), and the Quot/Grassmannian foundations (QUOT). End-state:
zero project `sorry` in the cone, zero project axioms, kernel-only axioms; names/labels match the
parent so finished work merges back.

## STRATEGY.md (verbatim)

(See `.archon/logs/iter-032/_strategy_snapshot.md` — read it in full.)

## References index

(See `references/summary.md` — Nitsure FGA Quot/Hilbert [primary]; Stacks 02KH [flat base change],
01I9 [widetilde pullback], 00K1 [Hilbert–Serre], 01PB [finite-type module]; Hartshorne AG.)

## Blueprint chapters (title, one-line topic)

- Cohomology_FlatBaseChange.tex — flat base change for the i=0 pushforward (FBC route).
- Cohomology_RegroupHelper.tex — regrouping iso for the affine base-change tensor tower (DONE).
- Picard_FlatteningStratification.tex — flattening stratification / generic flatness (GF).
- Picard_GrassmannianCells.tex — the Grassmannian over ℤ: charts, transitions, glued scheme, separated/proper.
- Picard_QuotScheme.tex — the Quot scheme: Hilbert polynomial, Quot functor, gap1 affine-descent infra.
- Picard_RelativeSpec.tex — relative Spec (downstream, for representability).

## Specific questions

1. FBC-A is OVER_BUDGET (~14 iters vs estimate 2–3). The iter-031 finding is that the prescribed proof
   route was never executable (a declaration-ordering bug). Is "one more corrective round, then escalate
   at iter-033" the right call, or should the route pivot now (e.g. the ModuleCat-level re-encoding fork
   in Open Q2)?
2. Is the gap1 4-step decomposition (C done → P1 → D keystone → assembly) still the right spine now that
   C is closed? Is D (section-localization descent, Stacks 01HA) correctly identified as the keystone?
3. Any structural concern with running GR-separated as a parallel lane now that the glued scheme exists?
