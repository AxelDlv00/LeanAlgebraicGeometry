# Algebraic Jacobian Challenge

A Lean 4 formalization of the Jacobian of a smooth, proper, geometrically
irreducible curve over a field.  The project takes the Picard-scheme route: build
the relative Picard functor, represent it, identify its identity component as an
abelian variety of dimension the genus, and derive the Albanese universal
property.  The first and last legs are substantially built; representability is
the open frontier.

Representability is being built by the **Milne–Kollár route** — construct
`Pic^r` over a separably closed field from the loci where `h⁰ = 1`, glue,
descend to `k` by a finite Galois quotient, assemble the degrees by a coproduct.
The plan of record is [`informal/pic-representability-campaign.md`](informal/pic-representability-campaign.md).
The Grothendieck/Kleiman quotient route via the Quot scheme is **not** the path
being built: its descent step needs a quasi-projectivity hypothesis that is not
expressible at the pinned Mathlib revision and without which the lemma is false.
Its substrate (Grassmannians, graded algebra, flattening stratification) is
sorry-free and is consumed by the committed route, so it is retained.

Two of the committed route's own engines are substantially built.  The rigidified
pushforward gate is **discharged**: `Adelic.instHasRigidPushforwardOfCurve` is a real
instance for every curve satisfying the challenge hypotheses, and it measures axiom-clean
at the synthesis site, as do the three extraction theorems that now synthesise it rather
than assuming it.  The finite Galois
quotient has Speiser descent, the affine quotient, and `Γ`-stable affine covers proved;
what remains there is gluing.  Both are stated with proofs and Lean pins in the
blueprint's FGA chapter, §"The Milne–Kollár route".  Neither route is hypothesis-free:
the quotient route needs quasi-projectivity of the Abel-map slice, the committed route
needs every finite Galois orbit to lie in an affine open, and the same Hironaka example
defeats both if its hypothesis is dropped.  The difference is that the orbit condition is
available for the schemes this route quotients.

It is developed alongside `Algebraic-Jacobian-Challenge-Rebuild`, which attacks the
same theorem by a separate curve-specialized strategy.

## State (measured 2026-07-28)

- **202 modules, 137,433 lines**; **28 `sorry`** over 11 modules, the rest locally
  sorry-free; a warm `lake build AlgebraicJacobian` **green** at 8,746 jobs (job count last
  measured before the 2026-07-28 lanes landed).  These counts move whenever a module lands, and
  four AJC lanes were live when they were taken, so re-measure rather than quoting them:

  ```bash
  find AlgebraicJacobian -name '*.lean' | wc -l          # modules on disk
  find AlgebraicJacobian -name '*.lean' -exec cat {} + | wc -l
  lake build AlgebraicJacobian 2>&1 | grep -c 'declaration uses .sorry'
  ```
- **Rootedness is worth measuring, not assuming.**  A module that nothing imports
  compiles green and is invisible *both* to the root build and to the axiom probe,
  with nothing warning about it — `import AlgebraicJacobian` never reaches it, so no
  `#print axioms` line for it can even be written.  The check is the second
  measurement in [`scripts/axiom-frontier.lean`](scripts/axiom-frontier.lean)'s
  header.  Modules land here from several parallel efforts, so the unrooted set is
  routinely non-empty for a short while: a module not yet committed to the workspace
  ledger must **not** be rooted, since a clean checkout would then fail to build.  That
  grace period ends at the commit — once a module is in the ledger, leaving it unrooted
  means the build does not check it.
- **Locally sorry-free is not axiom-clean.**  Two `sorry`-bodied *instances* leak
  through typeclass synthesis: `instHasPicScheme`
  (`Picard/FGAPicRepresentability.lean`, the sole producer of `HasPicScheme`) and
  `pullback_preservesFiniteLimits`
  (`Cohomology/CechHigherDirectImageUnconditional.lean`).  A theorem that merely
  *quantifies over* such a gate reports clean axioms, because the hypothesis is
  discharged by the caller; the leak appears at any call site that must
  synthesise the instance.  Run
  [`scripts/axiom-frontier.lean`](scripts/axiom-frontier.lean) (`lake env lean
  scripts/axiom-frontier.lean`, 126 declarations: 84 clean and 42 carrying `sorryAx`,
  measured 2026-07-28 with the root build green at 8,746 jobs) before believing any
  completeness claim — it measures the frontier rather than inferring it.  Count by
  output *entry*, not by output line:
  Lean wraps a long axiom list across several lines, so a per-line filter
  misclassifies exactly the declarations with the longest lists.  The header carries
  the recipe.
- **A clean axiom set answers one question only:** is a `sorry` reachable from this
  proof term.  Eight separate things it cannot see have each been found in this
  tree — a `sorry`-bodied instance reached only through synthesis; an *unproved*
  named hypothesis in the statement; a *false* named hypothesis in the statement,
  which makes the theorem vacuously true and perfectly clean; an
  *un-instantiable instance binder*, where the obligation sits in square brackets
  and nothing in the project constructs it for the ambient object actually used
  (an instance for a more structured cousin — `Over (Spec k)` rather than a bare
  `Scheme` — does not count, and is worse than none, because the grep succeeds);
  an *unrooted module*, which no axiom check reaches at all, per the bullet
  above; and an *instance diamond*, where two non-definitionally-equal instances can
  supply the same binder, so a file can prove correct-looking theorems about a
  definition pinned to the wrong one; and a *refutable* hypothesis, whose negation the
  tree already derives at every instance anyone would use, so the project proves both
  `H → C` and `¬H` and the theorem is true, clean, consistent, instantiable and empty.
  The first five are each measured by the probe; the sixth defeats the probe *and* an
  instantiability check, because the binders do synthesise — the tell is a cross-file
  identity that ought to be `rfl` and is not.  The seventh defeats every check in this
  file including a consistency witness: the only thing that finds it is reading the
  *producer's* side conditions and asking where the family the hypothesis quantifies
  over contains a member whose negation the tree proves (measured on the χ-ledger's
  `hbump`, probe §2b).  The eighth is the cheapest to check and worth checking first: a
  hypothesis *equivalent* to the conclusion it is supposed to buy, so that `H → C` is a
  restatement rather than a reduction — try to prove `C → H` before believing the
  reduction (probe §2c).  Read the probe's section headers, not just its output lines.
- **Only two of the tree's `sorry` carriers are instances**, and that is the whole of
  the synthesis-leak surface, because an instance is the only carrier a consumer can
  reach without naming it.  The probe's §2 lists all 26 carriers by module (the two
  instances plus 24 theorems and definitions), so the claim is checkable rather than
  folklore; note that two of those 24 hold their `sorry` in a *field*, which a grep
  for `:= sorry` misses.  Re-derive rather than trust the number:

  ```bash
  lake build AlgebraicJacobian 2>&1 | grep 'declaration uses' | sort -u
  ```
- 66 modules still open with a bare `import Mathlib`; this is the
  dominant build cost and is being converted bottom-up with the helpers in
  `scripts/`.

## Decision made: the headline is stated over an arbitrary field

**Settled 2026-07-28 by the project owner** (roadmap `AJC.picrep.rational-point`,
inbox `I-0372`, protection `I-0491`).  The Jacobian headline is stated over an
**arbitrary** base field with **no** rational-point hypothesis, and what gets
represented is the **étale-sheafified** relative Picard functor.  This is Kleiman's
own formulation and the full strength the challenge asks for.  It is not a branch to
revisit.

What that means concretely, and each piece is checkable:

- `Picard/PicEtSheaf.lean` builds the étale-sheafified relative Picard functor
  `Pic_{(C/k)ét}` and **proves its sheaf property** (`picEt_isSheaf_forget`) — it is
  a sheafification, so the axiom holds by construction rather than by hypothesis.  The
  étale site is Mathlib v4.31's `Scheme.etaleTopology` localised at `Spec k` along
  SGA 4 III 5.2.1.  The file is `sorry`-free.
- `Scheme.fgaPicardRepresentability` (`Picard/FGAPicRepresentability.lean`) is the
  representability obligation, restated for that functor with no rational point.  It
  is **one named `sorry`** and is the project's central open obligation; it is
  expected to stay open, and that is the honest state rather than a defect.
- `hasRationalPoint_of_curve` has been **deleted**.  It asserted a `k`-rational point
  from the challenge hypotheses alone, which is *false* — a conic over `ℚ` without
  rational points, or a genus-2 curve over `ℚ` without one, satisfies every other
  hypothesis.  While it existed the witness rested on an inconsistent hypothesis, so
  its consequences were vacuously true and no axiom check could tell.  It must never
  be proved or reinstated.
- `picardJacobianWitness` now carries exactly the three challenge hypotheses
  (`SmoothOfRelativeDimension 1`, `IsProper`, `GeometricallyIrreducible`) and nothing
  else.  This is checked, not asserted: `scripts/axiom-frontier.lean` has a
  `HeadlineBinders` section whose `example`s stop elaborating if a
  `[HasRationalPoint _]` binder ever returns to the headline cone.

**The obligation count is unchanged at five, and that is the deliverable.**  The
witness rests on `fgaPicardRepresentability`, `Pic0Et.smooth`, `Pic0Et.proper`,
`smoothOfRelativeDimension_genus_pic0Et` and `isAlbanese_pic0Et`.  What changed is not
the number but the *kind*: **none of the five is a false statement any more**.  All
five are true statements awaiting proofs.  That difference is invisible to
`#print axioms` — it is a property of the statements, not of the proof terms — which
is why it is argued at the binders instead.

Two things are kept beside the headline and **neither may be presented as it**:
`picardJacobianWitnessOfHasRationalPoint`, an explicitly *conditional* milestone
(true under a section, strictly weaker than the challenge), and
`picardJacobianWitnessOfIsAlgClosed`, a genuine theorem over `k̄`.  The
`picSharp`-shaped gate `HasPicScheme` survives for the consumers written against it,
but it is **no longer an instance**: its only producer is the named theorem
`picSchemeOfHasRationalPoint`, so nothing picks up a rational-point hypothesis by
synthesis.

The route choice is unaffected: Milne–Kollár stays committed, Quot stays
retained-not-revived.


Cones closed: `AJC.substrate`, `AJC.linebundle`, `AJC.grquot`, `AJC.cech`.
Cones open: `AJC.fbc` (flat base change, three leaves), `AJC.rr`, `AJC.picrep`
(Picard representability), `AJC.pic0av` (Pic⁰ is an abelian variety),
`AJC.albanese`.  Run `horizon roadmap list --focus AJC.jacobian` for the live tree
— the roadmap, not this file, is the authority on status.

## Navigation

- [`AlgebraicJacobian.lean`](AlgebraicJacobian.lean): project import root.
- [`AlgebraicJacobian/Jacobian.lean`](AlgebraicJacobian/Jacobian.lean): the final
  Jacobian witness interface and assembly point.  The witness is built from
  `Pic⁰_{C/k}` in its étale form (`Picard/Pic0Et.lean`) and carries **no**
  rational-point hypothesis.  It depends on five stated obligations:
  `fgaPicardRepresentability` (the representability of `Pic_{(C/k)ét}`),
  `Pic0Et.smooth` and `Pic0Et.proper` upstream, plus the two leaves
  `smoothOfRelativeDimension_genus_pic0Et` and `isAlbanese_pic0Et` stated there.  All
  five are **true** statements awaiting proofs.  The two leaves carry *companions*
  stating what the landed development already reaches
  (`finrank_tangentSpace_pic0_eq_genus`, `isAlbanese_pic0_of_isAlgClosed`), so each
  leaf's remaining distance is compiler-checked rather than described in prose; both
  companions record a distance and carry `sorryAx`, and the probe's §0 says why.
- [`scripts/axiom-frontier.lean`](scripts/axiom-frontier.lean): the axiom-frontier
  probe, and the three companion measurements in its header: reachability of the
  headline cone, whether every module on disk is rooted at all, and whether every
  blueprint proof-level `\leanok` is honest.  The last has to be a `#print axioms` join
  rather than a reading pass, because a `\leanok` is a local mark while the defect is
  transitive — a proof written in Lean is still not proved if it routes through a `sorry`.
  The `\leanok` join is executable — `scripts/leanok-audit.sh`, one command from the
  project root, exiting non-zero if any of its three checks fails (the reconciliation
  identity on each mark position, plus a positive control proving the `private` lane
  still bites).  Run it rather than re-transcribing it: every wrong number this check has
  published came from a recipe copied out of a comment and drifting from the code that
  produced it.

  Current result, both mark positions under the same reconciliation identity:
  **proof-level, 1073 pinned declarations across 1078 marks = 930 public + 143 `private`,
  zero carrying `sorryAx`; statement-level, 1560 declarations across 1567 marks = 1372
  public + 188 `private`, of which 34 carry `sorryAx`.**  Only the proof-level zero is a
  defect count: a statement-level mark on a `sorry` carrier is legitimate, since it claims
  the signature is formalised.  Do not delete those 34.

  Read that check's own history before writing another one, because it is the sharpest
  cautionary tale in this tree.  Its first version reported three dishonest marks; all
  three were artifacts of its regex pairing one node's statement with a *later* node's
  proof, and one of them had already been settled correctly, by reading, in a commit
  message.  Fixing it exposed **six** separate ways it had been silently examining a
  strict subset of its domain while printing a clean-looking result — and the last three
  were found only because the corrected version *asserts* that
  `public + private + unresolved == pins` and the assertion failed.  The lesson is not
  "machines beat reading": it is that a mechanical audit needs an arithmetic identity it
  must satisfy, checked in code, or "it printed 0 defects" means only that it printed.

  Two sharper lessons came out of correcting the correction, and both generalise past
  `\leanok`.  The statement-level count above stood as "eleven" for two revisions, and
  eleven was *precisely* the intersection with the probe's own output — the very artifact
  the paragraph above retracts, still live one paragraph below its own retraction.  So a
  domain bug is not fixed when its instance is: every other figure derived by the same
  route needs the same identity.  And the 143 `private` pins were published twice as
  undecidable, which is true of `#print axioms` and false of `Lean.collectAxioms`; all
  1073 are decided, with a positive control to show the private lane is not vacuously
  clean.  "My probe cannot see it" is a fact about the probe.
- [`blueprint/web/index.html`](blueprint/web/index.html): generated mathematical blueprint.
- [`analogies/README.md`](analogies/README.md): index to the historical design notes.
- [`../Algebraic-Jacobian-Challenge-Rebuild/README.md`](../Algebraic-Jacobian-Challenge-Rebuild/README.md):
  the alternative Rebuild route.

## Layout

- `AlgebraicJacobian/Cohomology/`: sheaf cohomology, the finite-cover Čech
  complex, higher direct images, and flat base change.
- `AlgebraicJacobian/Picard/`: line bundles, relative Spec, the relative Picard
  functor, Grassmannians, Quot schemes, flattening stratification, and Picard
  identity components.
- `AlgebraicJacobian/Albanese/`: rigidity and extension of rational maps, plus the
  Albanese factorization.
- `AlgebraicJacobian/RiemannRoch/`: divisor and adelic Riemann–Roch infrastructure.
- `blueprint/src/chapters/`: the mathematical blueprint.
- `hgraph/`: the generated statement/declaration dependency graph.
- `scripts/`: import-minimization and budget-trimming helpers (`min-imports.sh`,
  `deumbrella.sh`, `deumbrella-wave.sh`, `trim-budgets.sh`).  They drive
  `lake env lean`, never `lake build`, so they do not invalidate the build tree.
- `informal/`, `memory/`, `analogies/`: campaign plans, durable notes, and
  historical design notes.  See each directory's own index.
- [`../../references/summary.md`](../../references/summary.md): shared source
  bibliography and retrieval notes.

## Build

Lean and Mathlib are both pinned at `v4.31.0`.

```bash
lake exe cache get
lake build
```

For faithful checks, prefer the configured module target.  `lake env lean <file>`
does not apply every option from the lakefile's `[leanOptions]` — in particular
`maxSynthPendingDepth` — so a direct-file-only instance-synthesis failure can be an
option mismatch rather than a source regression.  Files that rely on that option
carry a local `set_option` so direct-file, LSP, and module checks agree.

This project is part of an Archon Horizon workspace.  Roadmap, task, inbox, and
cross-project state live at the workspace root and are reached through the
`horizon` CLI.
