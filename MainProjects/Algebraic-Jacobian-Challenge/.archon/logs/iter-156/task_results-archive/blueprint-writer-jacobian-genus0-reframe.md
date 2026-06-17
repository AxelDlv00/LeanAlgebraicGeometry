# Blueprint Writer Report

## Slug
jacobian-genus0-reframe

## Status
COMPLETE — genus-0 framing re-pointed off the differential/Serre route onto the
decoupled rigidity statement (object `Spec k`) with ranked routes (c lead / b / a
fallback); Route A asserted as the mandatory critical path for the positive-genus
object; a route-(c) rigidity-lemma block (the Milne theorem-of-the-cube → rigidity →
Thm 3.2 → Prop 3.10 chain) added with verbatim citations read from
`references/abelian-varieties.pdf`.

## Target chapter
blueprint/src/chapters/Jacobian.tex

## Changes Made

### Re-pointing off the differential `df = 0` route (directive item 1)
- **Revised chapter intro (top of file).** Replaced the "Picard machinery is blocked,
  so we use the Albanese-functor alternative" framing with: positive-genus object =
  `Pic⁰_{C/k}` via Route A (committed critical path, mandatory even when `C(k)=∅`);
  genus-0 object = trivial `Spec k`, decoupled, remaining content = rigidity statement
  `thm:rigidity_over_kbar` proved by the char-free route (c), NOT the differential/Serre
  route.
- **Revised C.2.d** (`thm:nonempty_jacobianWitness` proof). Removed the loose
  memory-cited Mumford `\begin{quote}` and restructured the "key classical input" into
  three explicitly ranked routes: **(c) [committed, char-free]** theorem-of-cube →
  rigidity → Prop 3.10 (pointing to the new blocks); **(b) [fallback]** dual abelian
  variety (kept, flagged as coupling genus-0 to Route A representability); **(a)
  [fallback, off critical path, char-`p` gap]** the cotangent/`df=0` differential route
  (kept verbatim, demoted, flagged as Serre-duality-flavoured + chart-algebra envelope
  supplies only the converse).
- **Revised C.2.g** (Mathlib gap statement). `rigidity_over_kbar`'s committed proof
  route is now stated as route (c) (char-free, `sec:av_rigidity_route_c`); the
  cotangent-vanishing pile (i)+(ii)+(iii) demoted to fallback (a), retained in tree.
  Noted the live signature also carries `[CharZero k̄]`, removable once route (c) lands.
- **Revised infrastructure summary (γ).** Re-pointed: genus-0 needs only the rigidity
  *statement*, decoupled from BOTH the cotangent pile AND representability; committed
  route is (c); cotangent pile demoted to fallback (a).
- **Revised Layer I.** Re-pointed the rigidity-establishment clause to route (c)
  (char-free, decoupled), cotangent pile as fallback (a); kept the descent step.
- **Revised `sec:genusZeroWitness` intro + `def:genusZeroWitness` body-closure
  paragraph + the `[IsAlgClosed]` parenthetical** in the existence paragraph: closure
  gated on `rigidity_over_kbar` via committed route (c); fallback (a) = cotangent pile;
  noted the current `[CharZero k̄]` hypothesis is removable under route (c).

### Route A as mandatory critical path (directive item 2)
- **Revised infrastructure bullet (α).** Added: Route A is mandatory and unconditional
  for the positive-genus *object* (must be a genuine `g`-dim AV `Pic⁰`), independent of
  the genus-0 route choice; the two arms are fully decoupled. Noted the universal-
  property step A.4 is Milne Prop 6.1 (Albanese property).
- **Revised `def:positiveGenusWitness` intro.** Added: Route A mandatory/unconditional
  for the positive-genus object, independent of the genus-0 route.

### Route-(c) rigidity-lemma block (directive item 3)
Added a new subsection `\subsection{Route (c): rigidity via the theorem of the cube ...}`
(`\label{sec:av_rigidity_route_c}`) just before `def:genusZeroWitness`, containing the
Milne chain, each block with `% SOURCE:` (+ `(read from references/abelian-varieties.pdf)`),
verbatim `% SOURCE QUOTE:`, and `% SOURCE QUOTE PROOF:` where applicable:
- **`thm:theorem_of_the_cube`** — Milne Thm 5.1 (statement; proof deferred in source).
- **`lem:rigidity_theorem`** — Milne Thm 1.1 Rigidity Theorem (statement + full proof).
  - Proof sketch added: Y (restated in project notation).
- **`cor:complete_product_to_AV_decomp`** — Milne Cor 1.5 (statement; proof opening
  quoted, remainder on PDF p.16 flagged not-transcribed — it is the Rigidity-Theorem
  application).
- **`lem:rational_map_to_AV_extends`** — Milne Thm 3.2 (statement + 1-line proof quote).
- **`prop:unirational_to_AV_constant`** — Milne Prop 3.10 (statement + unirational
  definition + full proof quote).
  - Proof sketch added: Y.
- **`prop:rigidity_genus0_curve_to_AV`** — headline project specialisation to a genus-0
  curve / `ℙ¹_{k̄}` (the directive's required statement: pointed morphism from a smooth
  proper geom-irred genus-0 curve over `k̄` to an AV is constant). Cites Milne Prop 3.10.
  - Proof sketch added: Y (genus-0 + k̄-point ⇒ `ℙ¹` ⇒ unirational ⇒ Prop 3.10; pointed
    condition pins the value; explicitly char-free, no `df=0`, no Serre duality, no
    representability).

## Cross-references introduced
- `\uses{thm:theorem_of_the_cube}` in `lem:rigidity_theorem` — defined this chapter. ✓
- `\uses{lem:rigidity_theorem}` in `cor:complete_product_to_AV_decomp` + rigidity proof. ✓
- `\uses{lem:rational_map_to_AV_extends, cor:complete_product_to_AV_decomp}` in
  `prop:unirational_to_AV_constant`. ✓
- `\uses{prop:unirational_to_AV_constant, lem:rational_map_to_AV_extends}` in
  `prop:rigidity_genus0_curve_to_AV`. ✓
- `\cref{sec:av_rigidity_route_c}`, `\cref{prop:unirational_to_AV_constant}`,
  `\cref{prop:rigidity_genus0_curve_to_AV}` added in C.2.d, C.2.g, (α), (γ), Layer I,
  both genus-0/positive-genus intros, and the body-closure paragraph — all targets
  defined in this chapter. ✓
- `\cref{thm:rigidity_over_kbar}` (lives in `RigidityKbar.tex`) — already cross-chapter
  referenced elsewhere in this file; resolves in the assembled blueprint. ✓

## References consulted
- `references/summary.md` — index; confirmed Milne is the rigidity/Albanese source.
- `references/abelian-varieties.md` — pointer file; PDF page-offset map (doc page N ↦
  PDF page N+6), contents map, mojibake caveat.
- `references/abelian-varieties.pdf` (Milne, *Abelian Varieties*, v2.00) — opened PDF
  pages **14–15** (Rigidity Theorem 1.1 + proof; Cor 1.5 statement), **22–23** (rational
  maps; Theorem 3.2 + proof; Lemma 3.3), **26** (unirational def; Proposition 3.10 +
  proof), **27** (Theorem of the Cube 5.1), **110–111** (Albanese Prop 6.1/6.4) — these
  back every `% SOURCE QUOTE` in the new route-(c) blocks and the Prop 6.1 mention in (α).

### Extraction-method disclosure (important for the reviewer's verbatim check)
The Read tool **cannot render this PDF** on the host (poppler/`pdftoppm` not installed;
the error was reproduced). I extracted the text layer via `pypdf` instead. pypdf mangles
some glyphs deterministically (documented in `references/abelian-varieties.md`):
`/STX`→×, `/NUL`→ −/⁻¹/Γ (context), `/SUB`→⊆, `/ETX`→∗/∨, `→→↖ ↖ ↖`→⇢, `\smallsetminus`
for set-minus. The `% SOURCE QUOTE` comments restore the standard mathematical glyphs the
rendered PDF displays (e.g. `V × W`, `α⁻¹`, `⊆`); they are faithful transcriptions of the
text I actually read, not memory reconstructions, but they are **not byte-identical** to a
poppler render because of this glyph normalization. The Cor 1.5 proof remainder (PDF p.16)
was not fetched and is explicitly flagged in-comment as not-transcribed.

## Macros needed (if any)
- None new. `\dashrightarrow` (used for rational maps) is provided by `amssymb`, which is
  loaded in both `blueprint/src/print.tex` and `blueprint/src/web.tex` (verified). All
  other commands (`\Spec`, `\Pic`, `\genus`, `\mathbb P`, `\bar k`) are already in use.

## Reference-retriever dispatches (if any)
- None. `references/abelian-varieties.pdf` was already in tree (retrieved iter-155/156).

## Notes for Plan Agent
- **`% NOTE:` review item (1) still pending** (lines in `def:genusZeroWitness` proof):
  the *uniqueness* paragraph still justifies uniqueness of `g` by the terminal-object
  property, which the NOTE correctly calls mathematically loose (morphisms *out of* a
  terminal object are global points, not unique). I did NOT rewrite it — `% NOTE:` is the
  review agent's domain and the directive scoped me to the route reframe. The sound fix
  (epi-cancellation of `toUnit C` via `Flat.epi_of_flat_of_surjective` +
  `Over.epi_of_epi_left` + `cancel_epi`) is already used in the *existence* paragraph
  just above it, so the rewrite is a small, local follow-up for a future writer/review.
- **`% NOTE:` review item (2) partially addressed.** I corrected the understated
  `rigidity_over_kbar` signature description: it now reads `[IsAlgClosed k̄]` **and**
  `[CharZero k̄]` (char-`p` excluded by hypothesis, not yet Frobenius-handled) in the
  existence paragraph, C.2.g, (γ), and the body-closure paragraph, with the explicit note
  that route (c) is char-free and would let `[CharZero k̄]` be dropped. The `% NOTE:`
  comment block itself I left intact (review owns it).
- **Cross-chapter consistency the directive flagged as separate tasks (out of scope for
  me):** `RigidityKbar.tex` still likely says it "commits to neither route" and frames
  `rigidity_over_kbar` via the cotangent-vanishing pile as the live path — that chapter
  needs the same (c)-committed / (a)-fallback reframe to match Jacobian.tex. Likewise
  `AbelJacobi.tex` classical-description prose. I did not touch them.
- **Route A future build-out:** Milne **Prop 6.1/6.4** (PDF p.110–111) is now read and
  citable — it is the Albanese universal property backing Route A's sub-step A.4. When the
  Route A prover-ready build-out round happens, that citation is ready to drop in (I added
  only a light mention in (α), not a full block, per the out-of-scope instruction). The
  smallest named entry point recorded in the chapter remains `RelativeSpec` (A.1).

## Strategy-modifying findings
- None. The reframe *implements* an already-made strategic decision (genus-0 committed to
  route (c)); it did not surface a new strategy-level issue. One worth the planner's
  awareness but not strategy-changing: route (c) being characteristic-free means the
  genus-0 arm can ultimately shed the `[CharZero k̄]` hypothesis that the current Lean
  `rigidity_over_kbar` signature and the fallback (a) carry — i.e. route (c) is strictly
  stronger than fallback (a) on the char-`p` axis, reinforcing the (c)-lead ranking.
