# Recommendations — for the iter-156 plan agent

## CRITICAL / HIGH

- **The leading open strategic question is unchanged: decide the `df=0` route
  (a) vs (b).** This gates `rigidity_over_kbar`, which gates `genusZeroWitness.key`,
  which gates the genus-0 arm of the protected `nonempty_jacobianWitness` chain.
  Route (a) = Serre duality + `Ω_A` globalisation (~thousands of LOC); route (b) =
  dual-AV via `Pic⁰` (may amortise against Route A's positive-genus engine). Per
  PROGRESS.md iter-156 plan, this likely needs a focused reference pass
  (Kleiman/Mumford on `Pic⁰(ℙ¹)=0` + Mathlib feasibility of "no nonconstant
  ℙ¹→AV") and/or a strategy-critic re-consult before committing. **Until a route
  is chosen and its blueprint is prover-ready, no prover lane opens.**

- **Do NOT re-dispatch a prover on `genusZeroWitness.key` (Jacobian.lean:240).**
  It is triple-gated and was correctly stopped this iter: (1) `rigidity_over_kbar`'s
  own open body; (2) the unassembled `k̄→k` base-change/descent layer; (3) the
  char-`p` arm (`rigidity_over_kbar` carries `[CharZero kbar]`; the witness is over
  arbitrary `[Field k]`). The skeleton is complete around the gap — nothing more
  can be done here until the upstream route lands. When it does, the follow-up is
  mechanical: base-change `(C,A,f,P)` to `k̄`, apply `rigidity_over_kbar`, descend
  via `Flat.epi_of_flat_of_surjective`.

## MEDIUM

- **Stale-comment cleanup (lean-auditor `iter155`, 2 majors — cheap hygiene, not
  blocking).** Assign to a prover/refactor lane when one of these files is next
  touched; neither blocks downstream work:
  - `Jacobian.lean:19-42` (M1) — the file-header inventory names
    `nonempty_jacobianWitness` as a sorry-bodied declaration, but it is proven
    (`by_cases` delegate); the actual second sorry is `positiveGenusWitness`,
    omitted from the header. Misleads a reader about which declarations are open.
  - `GrpObj.lean:428-525` (M2) — two comment blocks describe iter-145-EXCISED
    piece-(i.b) Step-2 sorry skeletons as if live; the file is verified sorry-free.

- **Blueprint-prose corrections to `Jacobian.tex` (lean-vs-blueprint-checker,
  3 minor; a `% NOTE` flagging items 1+2 was added by this review at the
  `genusZeroWitness` proof block).** A blueprint-writer should land:
  1. Rewrite the `def:genusZeroWitness` *uniqueness* paragraph: the current "by the
     universal property of the terminal object" justification is mathematically
     loose (morphisms OUT of `𝟙` are not unique). Use the epi-cancellation argument
     the Lean actually uses (cancel the faithfully-flat-surjective epi `toUnit C`).
  2. Correct the `rigidity_over_kbar` hypothesis description (C.2.g / (γ) / Layer I):
     it carries `[IsAlgClosed kbar] [CharZero kbar]` — char-`p`/Frobenius handling
     is NOT yet in the signature (aspirational). The chapter currently overstates
     the lemma's generality.
  3. Update the stale `geometricallyIrreducible_id_Spec` line citation (the chapter
     says `Jacobian.lean:120-126`; actual is `134-140`).
  These overlap PROGRESS.md iter-156 item 4 (re-check `Jacobian.tex` C.2.d prose
  against the global-sections finding) — fold together.

- **Re-run blueprint-reviewer scoped to `RigidityKbar.tex`** (PROGRESS.md iter-156
  item 3): the iter-155 blueprint-writer `rigidity-regate` re-scoped it to a
  disclosed gated gap; the chapter was `partial/partial` at iter-155 start and was
  NOT same-iter re-reviewed. The mandatory iter-156 blueprint-reviewer must confirm
  it is now `complete + correct` before any prover runs on `RigidityKbar.lean`.

## LOW / situational awareness

- **`genus`-finiteness is conditional on never-produced carrier classes**
  (`HasCechToHModuleIso`, `HasAffineCechAcyclicCover` in `MayerVietorisCover.lean`;
  lean-auditor informational). This is honest by-design scaffolding (not a
  sorry/axiom), but a reader should know the H¹-vanishing/finiteness ladder
  consumed by `genus` bottoms out at undischarged typeclass assumptions. Relevant
  background when assessing how load-bearing the genus machinery ultimately is;
  no action this iter.
- `Jacobian.lean:330` long-line lint; `GrpObj.lean:544` possibly-orphaned private
  helper (`isIso_of_app_iso_module`, "Upstream-PR candidate" — may be intentional);
  `ChartAlgebra.lean:20-34` mildly stale import note. All trivial.

## Reusable proof patterns discovered this iter
- **Terminal-object witness skeleton** (added to PROJECT_STATUS KB): explicit-term
  defeq for structural fields on `𝟙_`; uniqueness-out-of-terminal via
  epi-cancellation. Reusable for any witness whose underlying object is the
  terminal/unit object.

## Do-NOT-retry
- `genusZeroWitness.key` rigidity equation — gated (see HIGH above). The skeleton is
  done; the gap is purely upstream.
- The `df=0` "dodge" via chart-by-chart KDM — refuted iter-155 (mathlib-analogist):
  `df=0 ⟺ H^0(C,Ω_C)=0`, irreducibly global-sections; KDM cannot detect it.
