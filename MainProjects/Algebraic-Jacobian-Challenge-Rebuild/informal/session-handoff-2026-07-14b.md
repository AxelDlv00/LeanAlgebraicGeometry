# Session handoff — 2026-07-14 (second interactive Fable session)

KERNEL-DISCIPLINE ADDITION (earned by the E1 coherence close, 2026-07-15): local-
notation-typed binders in `variable`/`include` sections do not only make declarations
silently vanish — they can also manifest as `whnf`/`isDefEq`/kernel timeouts on
otherwise-fine proofs; byte-identical statements with EXPLICIT binders elaborate at
default heartbeats. When a proof times out mysteriously near local notation, rewrite
the binders explicit before restructuring anything else. Also reusable: make repeated
morphism composites into opaque defs identified once each ("insertion" pattern), and
pay nested-vs-composite preimage conversions once over abstract schemes.

For the next agent continuing the `rebuild` task. Supersedes
`session-handoff-2026-07-14.md` (whose operating model and kernel/elaboration
discipline remain BINDING and are not repeated here — re-read its two protocol
sections; two amendments: (1) `LocallyOfFiniteType (X ↘ …)` is now a global instance
derived from `SmoothOfRelativeDimension 1`, so never add it as a hypothesis;
(2) DELEGATION UPDATE, user instruction 2026-07-15: Fable-5 usage is running low
against quota, so use Fable-5 SUBAGENTS liberally for the difficult tasks where Opus
is not enough — campaign hearts, risky design worksheets, keystone provers — not just
one or two per campaign leg. Opus still carries volume/recon/blueprint.
CONCURRENCY UPDATE (user instruction, 2026-07-15, supersedes "one prover at a time"):
PARALLEL PROVERS are allowed — the historical rule guarded lake-vs-LSP races during
package materialization only. Provers iterate concurrently via the lean-lsp MCP; ONLY
`lake` invocations serialize, via the mkdir spinlock
`/tmp/claude-1001/ajcr-locks/lake.lock` (hold only around the build, rmdir to release,
never steal; README in that dir). Provers get DISJOINT file scopes; the shared
AlgebraicJacobian.lean import list uses re-read-and-reapply-your-line. Every prover
spec must carry this protocol.
(3) ROADMAP ACTUALIZATION, user instruction 2026-07-15: keep the `horizon roadmap`
tree current at EVERY milestone — statuses AND subitems (`add --parent`) when a
campaign is designed or decomposed; it is the user's progress view. The degree lane,
(C2), and Wave 4 now carry subitems mirroring their worksheets — maintain them.
Titles/summaries render LaTeX + Markdown: PREFER MATHEMATICAL FORMULATION
(e.g. $\chi(\mathcal{O}(D)) = 1 - g + \deg D$), Lean names/commits as detail.)

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

1. **G-D4 status: recon landed (`informal/deg-d4-recon.md` — the graph divisor is a
   campaign; v4.31 has NO scheme-level effective-Cartier/regular-immersion/
   differentials API), and deg-D4a is LANDED (`704176f08d`,
   `Picard/LocalEquationsPullback.lean`, root 8675 jobs): `LocalEquations.pullback`
   under the bare regularity primitive (naive statement false; flatness corollary
   deliberately not built — the graph's morphism isn't flat) with the FULL class law
   `picClass_pullback` as a simp lemma.** Remaining: **deg-D4b** (diagonal local
   equations via standard-smooth charts — WORKSHEET-FIRST, the campaign heart) →
   deg-D4c (graph = pullback of diagonal; discharge `hreg` from the relative-divisor
   geometry; base change via `picClass_pullback` + section naturality). abelElement
   blocks on D4b, not on the deferred rank-1 certificate.
   BLUEPRINT DEBT (queue for one agent): the cbc-1 scaffold
   (`Cohomology/RelativeTwoCover.lean`) and deg-D4a (`LocalEquationsPullback.lean`)
   are landed but not yet blueprinted.
2. **G-D2 meromorphic bridge: W1–W4 LANDED (fbd77da540, Fable) + deg-D1 REPAIR LANDED
   (5d20fc70c5) + blueprinted (594dd02262).** Pic ≅ Div/principal at the cocycle level;
   the anchored map is `CurveDivisor.picClass` (carries (S)/(X)/kernel/additivity);
   `divisorClass_eq_picClass` bridges the legacy name. NOTE the audit finding pattern:
   deg-D1 had sealed its point equation behind a too-weak private postcondition —
   when a construction's defining property is discharged via `Exists.choose`, the
   postcondition MUST record everything downstream proofs need. W5 (classDeg +
   E-i..E-iii, Opus) was IN FLIGHT at handoff; then W6 (consumed by Wave-4 FLV).
3. **Wave 4: the datum design pass is DONE** (`informal/w4-datum-design.md`, committed)
   — decision: the twist normalizes (fiber twist Θ_n, two-cover-trivial by
   construction) but the universal class does not; **AJCR.cech-port is FIRED** (roadmap
   status pending, scope = exactly G-CBC-3(ii), re-derive along the rebuild's own Serre
   engine with the subproject's green theorem as certificate). Revised sequence:
   **w4-5** fiber-twist brick (zero deps, launchable in any prover slot) → **w4-1** the
   port (Fable heart) → w4-2 cbc-lite completion ∥ **w4-4 FLV** (fibrewise large-twist
   vanishing — the new biggest Wave-4 risk, WORKSHEET-FIRST, gates on G-D2 (S)/(X) and
   resurrects G-D2(i) as W6) → w4-3 rigid engine → w4-6+ datum campaign (own design
   pass; gates on pic0Functor, NOT on deg-D4b/abelElement).
   **deg-D4b: worksheet DONE and binding** (`informal/deg-d4b-worksheet.md`) — étale-
   factorization idempotent route (no Nakayama), hypotheses shrink to smooth₁ +
   separated, and NOTE: this mathlib snapshot HAS Scheme.Hom.ker (the D4 recon's
   premise is superseded). Six sub-bricks B0–B5 (B2/B4 Fable hearts).
4. (C2) campaign per `c2-effectivity-assembly.md`: E0 (Opus) then E1 (Fable, its own
   spec with the full ζ2·i treatment).
5. Blueprint per brick (pending: cbc-1's scaffold), roadmap statuses at milestones,
   task comments at campaign closes.

## Session ledger (this session's commits, newest last)

ee3b1d044f blueprint divisor/dévissage waves · 41faf586c8 degree recon ·
133a081296 G8 spec+dumps · 26f0712e4c (C2) recon · 711ee006cd (C2) worksheet ·
560403474e χ-ledger CLOSE · 52a673c615 blueprint χ close · f02bde54d4 Wave-4 recon ·
058d3f180a deg-D1 pointDivisor/divisorClass.
