# Session handoff — 2026-07-15 (continuation of the 07-14 interactive Fable session)

Supersedes `session-handoff-2026-07-14b.md` for STATE; that file's protocol amendments
(delegation: Fable liberally on hard cores; parallel provers with the lake mutex
`/tmp/claude-1001/ajcr-locks/lake.lock`; roadmap actualization, math-first, at every
milestone; raw-git ledger commits — recipe below; the kernel-discipline additions:
explicit binders instead of local-notation-typed section binders, the opaque-insertion
pattern) and the 07-14 handoff's kernel discipline remain BINDING.

## Commit recipe (horizon commit was removed in the user's CLI refactor)

```bash
GD=.archon-horizon/vcs/workspace.git   # from the workspace root
git --git-dir=$GD --work-tree=. add <files…>
git --git-dir=$GD --work-tree=. -c user.name="Archon Horizon" \
  -c user.email="archon-horizon@local" commit -m "<math-first message>

Archon-Commit: agent
Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```
`horizon task/roadmap/blueprint/inbox` still work (cwd = workspace root). The CLI is an
editable install under active user refactor — on "No such command", check `horizon -h`.

## State (root build 8723 jobs; zero sorries outside frozen Challenge.lean; blueprint
1912+ nodes 0 dangling; roadmap current — trust `horizon roadmap list` over prose)

**CLOSED this session:** Wave 2b (χ-ledger + RR-lite). Degree lane: divisor classes
(repaired + collapsed), the meromorphic bridge W1–W6-lite ($\mathrm{Pic} \cong
\mathrm{Div}/\mathrm{principal}$), the degree interface classDeg E-i..E-iii, base-change
instances, the graph campaign B0–B5+D4c ($[\mathcal{O}(\Delta)]$, $[\mathcal{O}(\Gamma_t)]$
with base change). **(C2) CLOSED**: `PicEtAff.unitEquiv_of_section` — relPic ≃*
PicEtAff over every field test with a curve point (effectivity for module-finite FF
covers, finiteness NECESSARY — counterexample in EffectivityMoving docstrings; the
general-base upgrade is a recorded frontier via a descent-aware moving lemma). Wave 4:
the probe, the fiber twist, the cech-port (QcohOn + twisted affine vanishing), and the
FULL FLV campaign (headline $H^1(\mathcal{O}(D+nF)) = 0$ for $n \ge n_0(D)$ + the class
form + the rank anchor $h^0 = \deg + \chi$).

**Key consumer-facing APIs** (per-brick reports live in the ledger commit messages —
`git --git-dir=$GD --work-tree=. log` and read the message of the commit touching the
file): `CurveDivisor.picClass` (+ (S)/(X)/kernel), `classDeg`, `chi_divisorSheaf`,
`ClassCohomology` transports, `Curve/BaseChangeInstances` (classDeg fires on C_K by
inference), `Over.graphPicClass` (= pullback of `diagonalPicClass`),
`PicEtAff.unitEquiv_of_section`, `QcohOn` + `subsingleton_hModule'_one_of_qcoh`,
`FLVClass.exists_subsingleton…of_one_le_classDeg…` + `h0_eq_deg_add_chi…`.

## Frontier (in rough priority order)

1. **w4-2 cbc-lite completion** (Opus): the F_g/cocycle-glued QcohOn constructor
   (structure-sheaf instance is the template), bundled CBC-1/2 base change for 𝒪
   (R-linear threading; the presheaf-transparency landmine is documented in the cbc-1
   report), per `informal/w4-cbc-recon.md` §2 G-CBC-4/5.
2. **G-D5(b) design pass** (Fable, read-only first): the class-level base-field shuffle
   $(C_K) \otimes_K K' \cong C_{K'}$ with deg/χ invariance — the degAt well-definedness
   core (the recon's second (C2)-style risk; a proved equality, never choice). Then
   G-D6 degAt → G-D7 pic0Functor → G-D8 abelElement (graph + point ingredients ready).
3. **w4-3 rigid engine + the datum design pass** (design first — w4-datum-design.md §4
   sequences it; FLV + the twist + the port hand it everything it asked for; the one
   dangling witness is the dominance export for the constructed π, recipe in the FLV-4
   report/docstring).
4. **(C2) general-base upgrade** (only if a consumer demands it): the descent-aware
   moving lemma — route in the E4 report/EffectivityClose docstrings.
5. Blueprint: the E4 slice was in flight at handoff (check the ledger; commit if landed
   and validated). W6-full stays at the datum seam.
6. Then Waves 5–7 per the roadmap (Pic⁰ abelian variety; Abel–Jacobi/Albanese;
   functoriality/base change) — each gets its own design pass first.

## Session ledger

~55 commits, 2026-07-14/15, every Lean landing independently audited (own root build
under the mutex, sorry census, own lean_verify on keystones) before its commit.

## ADDENDUM 2026-07-16 (Fable quota exhausted mid-wave; state at cut)

Root build **8730 jobs green**, zero sorries outside frozen Challenge.lean, tree clean,
everything committed.

**Landed since the 07-15 handoff:** the FLV dominance witness (`exists_isFinite_isDominant_toP1`
— exported from the construction; FLV campaign has NO frontier now); rigid-engine **RE-0**
(QcohOn⟹IsLocalizedModule bridge) + **RE-2** (Nakayama vanishing-propagation, openness of the
vanishing locus) + **RE-3** (module-coefficient rigidity: ker commutes with ⊗ and with every
base change; flat/projective kernel; the finite-projective dual-tensor-hom upgrade mathlib
lacked); **w4-2** (the cocycle-glued twisted sheaf `TwistedSheaf.lean`, `RelativeSectionsLinear`,
`RelativeH1BaseChange` — green and wired; its agent was quota-killed AT its final report, so its
consumer notes must be re-read from the file docstrings).

**Two worksheets landed and BINDING:**
- `informal/deg-d5b-worksheet.md` (Pic⁰ leg): NO geometric shuffle needed — both degAt
  well-definedness axes reduce to E-iv-alg (classDeg invariant under transition pullbacks) +
  a pasted IsPullback square. Sub-bricks SB-1..7. Balloon candidate: SB-3b.
- `informal/w4-rigid-engine-worksheet.md`: full Mumford II.5 DESCOPED — no finite-projective
  complex; Q = H⁰ itself, finite projective with universal module-coefficient base change;
  Noetherian quarantined to the H⁰-f.g. clause, eliminated by presentation descent (RE-5).
  Sub-bricks RE-0..RE-5.

**WIP committed but UNIMPORTED (do not wire the red ones until repaired; zero sorries in all):**
- GREEN, compile standalone: `Cohomology/RigidEngineLattice.lean` (RE-1a pair vocabulary),
  `Cohomology/RigidEngineLatticeSixTerm.lean`, `Curve/BaseFieldTransition.lean` (SB-1),
  `Algebra/LocalizedColength.lean` (SB-3a).
- RED, mid-edit: `Cohomology/RigidEngineLatticeModel.lean` (RE-1 models, 42 errors),
  `RiemannRoch/ChartColength.lean` (SB-3b, 23 errors).

**Frontier, in order:** (1) finish RE-1 (repair the models file, wire RigidEngineLattice*) →
RE-4 (sheaf assembly; both its gates — w4-2 and RE-1 — are now down or nearly) → RE-5;
(2) finish SB-3b (or stage around it) → SB-4/5 → SB-6/7 = degAt + pic0Functor → G-D8 abelElement
(graph + point classes landed); (3) the Wave-4 DATUM design pass (every engine input then in
hand) → the datum campaign → the frozen Jacobian targets; (4) blueprint debt: the C2-close pass
landed, but RE-0/2/3, w4-2, the dominance export, and everything after are UNBLUEPRINTED.
