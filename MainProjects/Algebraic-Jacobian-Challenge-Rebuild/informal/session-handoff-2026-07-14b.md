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

## Both former in-flight items LANDED and committed (audited)

1. **cbc-1 probe** (`c0c29a3d61`, `Cohomology/RelativeTwoCover.lean`, 175 lines, root
   8674 jobs): relative two-cover scaffold + CBC-0 carrier over R + H⁰(C_R) ≅ R +
   HModule' coefficient-iso transport. **VERDICT: GREEN on machinery, AMBER precisely
   at G-CBC-3(ii)** (twisted affine Serre vanishing — does NOT transport from 𝒪; the
   landed Serre engine is structure-sheaf-hardwired; port-bound to the KNOWN-GREEN
   AffineSerreVanishing.lean in SubProjects/Cech-Cohomology). No plan-B/C signal. The
   decision now lives in the **w4-rep.datum design pass**: if the universal twist can be
   normalized two-cover-trivial, `congrCoeff` transport suffices and no port is needed;
   otherwise trigger `AJCR.cech-port` as a BOUNDED port of that one statement (roadmap
   comments on AJCR.w4-rep.cbc and AJCR.cech-port record this). Remaining cbc-lite
   assembly (bundled CBC-1/2 for 𝒪 — R-linear threading over k-based tensor lemmas —
   and the F_g construction itself) is bounded follow-up, deprioritized deliberately.
2. **deg-D1 blueprint** (`03c25383b8`): 10 nodes incl. the previously-unblueprinted
   DivisorClass foundation; flagged future slice: `mul`/`restrict` invariance nodes.

## Next bricks, in order

1. **G-D4** (graph local equations, `Picard/GraphDivisor.lean`) — Opus prover, was
   being launched at handoff time; check the ledger. χ-independent, landed infra.
2. **G-D2 meromorphic-bridge campaign** — the WORKSHEET IS WRITTEN and binding:
   `informal/deg-d2-meromorphic-worksheet.md` (descoped to surjectivity + extraction;
   the D1 decision — all cochain comparisons inside K(X)ˣ — bounds the campaign; sub-
   bricks W1–W5 with W3 the staged heart). Launch W1 (Opus) from a spec derived from
   it; G-D3 = W5, last.
3. **w4-rep.datum design pass** — settle the twist-normalization question (see verdict
   above); it decides the cech-port trigger. Then the remaining cbc-lite assembly.
4. (C2) campaign per `c2-effectivity-assembly.md`: E0 (Opus) then E1 (Fable, its own
   spec with the full ζ2·i treatment).
5. Blueprint per brick (pending: cbc-1's scaffold), roadmap statuses at milestones,
   task comments at campaign closes.

## Session ledger (this session's commits, newest last)

ee3b1d044f blueprint divisor/dévissage waves · 41faf586c8 degree recon ·
133a081296 G8 spec+dumps · 26f0712e4c (C2) recon · 711ee006cd (C2) worksheet ·
560403474e χ-ledger CLOSE · 52a673c615 blueprint χ close · f02bde54d4 Wave-4 recon ·
058d3f180a deg-D1 pointDivisor/divisorClass.
