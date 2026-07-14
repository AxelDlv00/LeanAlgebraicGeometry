# Session handoff — 2026-07-14 (second interactive Fable session)

For the next agent continuing the `rebuild` task. Supersedes
`session-handoff-2026-07-14.md` (whose operating model and kernel/elaboration
discipline remain BINDING and are not repeated here — re-read its two protocol
sections; only one amendment: `LocallyOfFiniteType (X ↘ …)` is now a global instance
derived from `SmoothOfRelativeDimension 1`, so never add it as a hypothesis).

## What landed this session (all committed; kernel-green; independently audited)

**Wave 2b (χ-ledger + Riemann–Roch-lite) is CLOSED** (`560403474e`, Fable-authored,
spec `informal/spec-chi-g8-g9.md` + four verbatim API dumps `informal/api-chi-*.md`):
`RiemannRoch/Chi.lean` (h⁰/h¹/χ + iso transport, general small site), `ChiSlice.lean`
(the six-term covariant Ext slice packaged once, endpoints included;
`FiniteDimensional.of_exact`), `ChiFiniteness.lean` (`CurveDivisor.single` calculus,
`devissageDivisor_eq_sub` is rfl, the reusable `induction_devissage`, the finiteness
instances for every 𝒪(D)), `ChiLedger.lean` (chi_step, chi_divisorSheaf, deg_divOf,
riemann_inequality, h0_nsmul_point_unbounded), `ChiCurve.lean` (the k-linear Γ≅k seam,
h⁰(𝒪_C)=1, χ(𝒪_C)=1−genus C, RR-lite χ(𝒪(D))=1−g+deg D + curve corollaries, all keyed
on the genus `letI` spelling). Layer A is CONDITIONAL on the two structure-sheaf
finiteness instance-hypotheses (properness enters only there). Root build 8672 jobs at
that commit. Roadmap `AJCR.w2-chi` + both leaves → done. Blueprinted end-to-end
(`ee3b1d044f` 40 nodes for the divisor/dévissage waves; `52a673c615` 32 nodes for the
close; chapter validates 1506 nodes, 0 dangling).

**Degree lane opened** — recon `informal/degree-pic0-recon.md` (`41faf586c8`): 8 gaps
G-D1..G-D8 in dependency order, interface ledger to design §6's E-i..E-iv/degAt/
pic0Functor/abelElement; verified degAt does NOT gate on (C2). First brick deg-D1
LANDED (`058d3f180a`): `Picard/PointDivisor.lean` — `pointDivisor` (uniformizer on a
Dedekind chart isolated to one zero, 1 on the complement) and total
`divisorClass : CurveDivisor → CechPic` by Finsupp ℤ-power product, with additivity and
the single-point normalization anchor; uniformizer-choice independence deliberately
deferred (`picClass_rescale` when needed). Root build 8673 jobs. API gotcha for
consumers: use `CurveDivisor.single hx n`, never raw `Finsupp.single` inside +/−/•
(opaque-wrapper `binop%` failure); K is EXPLICIT in `pointDivisor K hx`.

**(C2) campaign fully designed** — recon `informal/zeta-c2-effectivity-recon.md`
(`26f0712e4c`) + the BINDING worksheet `informal/c2-effectivity-assembly.md`
(`711ee006cd`). The whole campaign is one effectivity brick (dual of the (C1) kernel
lemma) reached via sub-bricks E0–E4; decisions D1–D5 are made (Route A per-piece;
tracked descent data — the H¹-kernel argument for why class-only gluing FAILS is in D2;
refinement-splice reassembly; the σ-normalization design; campaign starts after the
degree first bricks). E1 (σ-normalized coherent cochain) and E3 (splice) are
Fable-grade; E0/E2/E4 Opus.

**Wave-4 early-warning designed** — recon `informal/w4-cbc-recon.md` (`f02bde54d4`):
cbc-lite statements pinned (two-cover CBC, no R^i f_*, no Hilbert polynomials), six
gaps, ONE campaign-risk gap (affine H¹-vanishing for a line bundle — the exact lemma is
already green in the cech-port contingency source), and the GREEN/AMBER/RED trigger:
AMBER → trigger `AJCR.cech-port`; RED → plan-B (Weil Sym^g) or plan-C (old-tree FGA).

## IN FLIGHT at handoff (check task notifications / ledger before assuming)

1. **cbc-1 prover** (Opus): `Cohomology/RelativeTwoCover.lean` per w4-cbc-recon §4 —
   relative two-cover CBC for 𝒪 + the F_g probe. Its report ends with an explicit
   GREEN/AMBER/RED verdict — ACT ON IT (§3 of the recon says how).
2. **deg-D1 blueprint agent** (Opus): a section continuing the LocalEquations/picClass
   chapter. Validate `horizon blueprint` (0 dangling) before committing.
If these landed and were committed already, the ledger will show it (project-git skill).

## Next bricks, in order

1. Audit/commit the two in-flight items above (protocol: own no-op root build, sorry
   census, own lean_verify on keystones, then `horizon commit` from the workspace root).
2. Act on cbc-1's verdict (GREEN → spec `w4-rep.datum`'s next brick or the general
   vanishing per the recon; AMBER → open the cech-port conversation; RED → plan-B/C
   decision, record it in the roadmap comments).
3. Degree lane: G-D4 (graph local equations) and/or the G-D2 meromorphic-bridge —
   G-D2 is the lane's biggest risk and is WORKSHEET-FIRST (like (C2); do not launch a
   prover from the recon alone). G-D3 (E-i..E-iii wiring) is now unblocked (χ landed).
4. (C2) campaign per `c2-effectivity-assembly.md`: E0 (Opus) then E1 (Fable, its own
   spec with the full ζ2·i treatment).
5. Blueprint per brick, roadmap statuses at milestones, task comments at campaign
   closes.

## Session ledger (this session's commits, newest last)

ee3b1d044f blueprint divisor/dévissage waves · 41faf586c8 degree recon ·
133a081296 G8 spec+dumps · 26f0712e4c (C2) recon · 711ee006cd (C2) worksheet ·
560403474e χ-ledger CLOSE · 52a673c615 blueprint χ close · f02bde54d4 Wave-4 recon ·
058d3f180a deg-D1 pointDivisor/divisorClass.
