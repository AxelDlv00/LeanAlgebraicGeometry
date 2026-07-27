/-
Axiom-frontier probe.  Not part of the library: run it with

    lake env lean scripts/axiom-frontier.lean

from the project root.  Every `#print axioms` line below reports the axioms a
declaration actually depends on, `sorryAx` included, so a declaration that is
locally `sorry`-free but consumes a `sorry`-bodied *instance* through typeclass
synthesis is exposed here and nowhere else.

What this probe does NOT establish is at least as important as what it does, so read
§6b, §6c and §8 before quoting any "clean" line as a completeness claim.  A clean axiom
set means one thing only: no `sorry` is reachable from that proof term.  It says nothing
about unproved or even false hypotheses carried in the statement.

Companion measurement — reachability of the headline.  `#print axioms` says what
the headline depends on; the import graph says what it *could* depend on.  A
headline importing only `Genus.lean` cannot rest on the Picard, cohomology or
Riemann-Roch work no matter what its docstring claims, so the size of its
transitive project-import closure is the honest check that the infrastructure is
wired to the stated theorem:

    python3 - <<'PY'
    import os, re
    def imports(m):
        p = m.replace('.', '/') + '.lean'
        return re.findall(r'^import\s+(AlgebraicJacobian[\w.]*)', open(p).read(), re.M) \
               if os.path.exists(p) else []
    seen, stack = set(), ['AlgebraicJacobian.Jacobian']
    while stack:
        m = stack.pop()
        if m not in seen:
            seen.add(m); stack += imports(m)
    total = sum(1 for _, _, fs in os.walk('AlgebraicJacobian') for f in fs
                if f.endswith('.lean'))
    print(f'{len(seen)} of {total} project modules reachable from the headline')
    PY

Re-measured 2026-07-28: 98 reachable modules of 187 on disk, and zero unrooted, up from
8 before `picardJacobianWitness` was wired to `Scheme.Pic0Scheme`.  The two most recent
additions are `Curve/GeometricallyReduced.lean`, which discharges the curve's geometric
integrality, and `Albanese/AlbaneseUP.lean`, which the headline now reaches because leaf C
is stated against the landed universal property (`isAlbanese_pic0_of_isAlgClosed`).
The denominator moves as modules land, so read the reachable count, not the ratio — and
note that the reachable count does *not* move when a module lands beside the headline
cone rather than under it, which is the normal case for the rigid-pushforward and
Riemann–Roch lanes.

How to read the output.  Every line is one declaration; the only token that matters is
`sorryAx`.  The clean/leaking split is worth summarising rather than eyeballing:

    lake env lean scripts/axiom-frontier.lean > /tmp/ax.txt
    python3 - <<'PY'
    import re
    entries = [e for e in re.split(r"\n(?=')", open('/tmp/ax.txt').read().strip())
               if e.startswith("'")]
    bad = [e.split("'")[1] for e in entries if 'sorryAx' in e]
    print(f'{len(entries)} probed, {len(entries) - len(bad)} clean, {len(bad)} carry sorryAx')
    for n in bad: print('  ', n)
    PY

Note the `re.split` rather than a plain line filter: Lean wraps a long axiom list over
several lines, so a per-line scan misclassifies exactly the declarations whose axiom
list is longest.  Measured 2026-07-28 through the root path, with `lake build
AlgebraicJacobian` green at 8746 jobs: **126 probed, 84 clean, 42 carrying `sorryAx`**
(125/84/41 before §0c added the branch-(1) assembly; 113/72/41 before §6f added the twelve
unconditional-χ lines; 107/70/37 before the two leaf-A lines in §0, the §0b obligation-count
pair, and the two chapter-keystone synthesis probes in §8).
Run the command above rather than adjusting this sentence's arithmetic by hand, which is
how the two previous counts here went wrong.

The `sorryAx` count is the one to watch, and the last two additions moved it in opposite
directions for the right reasons.  §6f added twelve declarations and left it at 41: a lane
whose declarations are all clean adds nothing to the frontier, which is the correct outcome
and also the reason a clean line is not by itself progress on the headline (§6b, §6d).  §0c
added one and moved it to 42, because the branch-(1) assembly leaks on the five obligations
behind it — five, because its `[HasRationalPoint C]` binder makes the gate FIRE exactly as
§0b describes, so the gate is among them.  Writing "four" here is the same miscount §0b
exists to prevent, and it was written and corrected once in this very paragraph.  Neither movement is a change in the mathematics — the frontier is the same five
obligations it was — which is why the number is worth re-measuring rather than reciting.

The two lines added last are the ones to read as a PAIR rather than individually, because
the gap between them carries the information. `hasRationalPoint_of_curve_of_isAlgClosed` is
clean — leaf A is a theorem over an algebraically closed field, so it is a discharge and not
a relocation. `picardJacobianWitnessOfIsAlgClosed`, the same witness assembled on it, still
leaks, and must: the synthesised gate `instHasPicScheme`, `Pic0.smooth`, `Pic0.proper` and
leaves B and C are open. What the pair establishes is that the residue over `k̄` consists of
five *true* statements awaiting proofs — five, not four; see §0b, which measures the gate
rather than letting the natural arithmetic drop it — where the general `picardJacobianWitness`
also carries a *false* one. Both witnesses report
`sorryAx` identically, so nothing in this file's output distinguishes them — which is exactly
why the discharge had to be exhibited rather than measured (compare §2b, trap (g)).

Of the two declarations added earlier on 2026-07-28, §0's leaf-B dimension count leaks (as
its own comment predicts — the dimension chain rests on
`finrank_cotangentSpaceDual_eq_finrank_h1Cok`) and §6c's gate at the challenge's own
hypothesis bundle is clean, which is the informative one: the rigid-pushforward gate is
available at the hypotheses of `Jacobian C` itself and not merely at a restatement of them.

One failure mode of this probe that is not a defect in it: `import AlgebraicJacobian` means a
single red module anywhere in the tree makes the whole frontier unmeasurable, and in a
workspace with several teams landing in parallel that happens. Distinguish the two shapes
before concluding anything — `object file ... does not exist` is a transient race with a
sibling's rebuild and is fixed by re-running `lake build AlgebraicJacobian` first, whereas a
`timeout at 'whnf'` or an elaboration error is a real red build and the frontier simply
cannot be quoted until it is green.

Companion measurement 2 — is every module on disk rooted?  A module that nothing
imports compiles green, is invisible to the root build, and is therefore invisible to
this probe as well: `import AlgebraicJacobian` does not reach it, so `#print axioms` on
its declarations cannot even be written here.  Replace the `stack` seed above with
`['AlgebraicJacobian']` and compare against the on-disk module list; the difference is
the set of modules whose axioms nobody is measuring.  It should be empty.

Companion measurement 3 — is every blueprint `\leanok` honest?  This one exists because
reading cannot answer it.  A `\leanok` is a local mark, but the defect is transitive: a
proof genuinely written in Lean is still not proved if it routes through a `sorry`, and
nothing at the mark says so.  So the mark has to be joined against `#print axioms`.

**The join must be over every proof-level mark, not over this file's output.**  That is
the whole design of the check and the earlier version of it got this backwards: it
intersected the marks with §0–§8, which name 126 declarations, so it could only ever
see the ~50 marked nodes this probe happens to mention.  Generate the `#print axioms`
lines *from the marks* instead.  Measured 2026-07-28 that way: **998 proof-level marks
pinning 1073 declarations, 891 of them resolvable and probed, and ZERO carrying
`sorryAx`.**

    python3 - <<'PY' > /tmp/leanok_pins.txt
    import re, glob, json
    ENVS = r'theorem|lemma|proposition|corollary|definition|remark|example|notation|convention'
    marked = []
    for fn in sorted(glob.glob('blueprint/src/chapters/*.tex')):
        # A `%`-comment can hold a \begin{proof} or an \end{theorem}; strip comments first.
        t = re.sub(r'(?<!\\)%[^\n]*', '', open(fn).read())
        for m in re.finditer(r'\\begin\{(' + ENVS + r')\}(.*?)\\end\{\1\}', t, re.S):
            stmt = m.group(2)
            lab = re.search(r'\\label\{([^}]*)\}', stmt)
            lean = re.search(r'\\lean\{([^}]*)\}', stmt)
            if not (lab and lean):
                continue
            # the node's own proof is the NEXT environment, if it is a proof at all
            pm = re.match(r'\s*\\begin\{proof\}(.*?)\\end\{proof\}', t[m.end():], re.S)
            if not (pm and '\\leanok' in pm.group(1)):
                continue
            for d in (x.strip() for x in lean.group(1).split(',')):
                if d:
                    marked.append((fn.split('/')[-1], lab.group(1), d))
    json.dump(marked, open('/tmp/marked.json', 'w'))
    for d in sorted({d for _, _, d in marked}):
        print(d)
    PY
    # `#print axioms` on an absent name is an ERROR, and `lean` stops at 100 of them,
    # silently truncating the audit.  Batch so no batch can reach the cap.
    split -l 40 /tmp/leanok_pins.txt /tmp/lk_ && rm -f /tmp/lk_all.txt
    for f in /tmp/lk_a*; do
      { echo 'import AlgebraicJacobian'; sed 's/^/#print axioms /' "$f"; } > /tmp/lk.lean
      lake env lean /tmp/lk.lean >> /tmp/lk_all.txt 2>&1
    done
    python3 - <<'PY'
    import re, json
    txt = open('/tmp/lk_all.txt').read()
    assert 'maximum number of errors' not in txt, 'audit truncated — use smaller batches'
    leaks = {m.group(1): 'sorryAx' in e
             for e in re.split(r"\n(?=')", txt)
             for m in [re.match(r"'([^']+)'", e)] if m}
    bad = [(l, d, f) for f, l, d in json.load(open('/tmp/marked.json')) if leaks.get(d)]
    print(f'{len(leaks)} pins probed, {len(bad)} dishonest proof-level marks')
    for l, d, f in bad: print('  DISHONEST', l, d, f)
    PY

Three failure modes of the naive version, each of which it exhibited, and all three
matter more than the arithmetic:

  1. **It required the proof to be textually adjacent** (`\end{theorem}\s*\n\s*
     \begin{proof}`).  Nodes in this tree routinely carry a `% SOURCE` comment block
     between statement and proof, so 452 of the 1311 pinned statement-with-proof pairs
     were never examined at all.
  2. **Non-greedy `(.*?)` then makes the regex reach PAST the true `\end{theorem}` to
     find an adjacent pair**, silently pairing one node's statement with a *later*
     node's proof.  It reported `thm:pic0_smooth` as claiming `\leanok` on a proof
     whose Lean is `sorry`; that "statement" in fact spanned nine `\label`s and the
     proof it picked up belongs to `thm:pic0_geom_irred`, which is proved and clean.
     Same shape for `thm:pic0_tangent_space_iso`, paired with
     `thm:dual_number_units_split`'s proof.  48 nodes were mis-attributed this way.
     **Both reported defects were artifacts: neither node carries a proof-level
     `\leanok` at all, and `git log` records that this is deliberate.**
  3. **`#print axioms` on an absent name is an error and `lean` halts at 100**, so a
     naive one-file audit reports on whatever it reached before the cap and looks
     complete.

What the corrected join does *not* cover, and it is a real bound rather than a
footnote: 143 of the 1073 pins name **`private`** declarations, which `#print axioms`
cannot address from outside their file even though they are genuine checked lemmas.
They concentrate in `Picard/TensorObjInverse.lean` (36), `TensorObjSubstrate.lean` (21)
and `Albanese/AuslanderBuchsbaum.lean` (21).  So the honest statement is: zero
dishonest marks among the 891 pins that can be probed, and 143 marks whose honesty
this method cannot decide either way.

Only *proof*-level marks are defects here.  A **statement**-level `\leanok` on a
`sorry` carrier is legitimate and there are eleven: it claims the signature is
formalised, which is true of a `sorry`-bodied declaration.  Do not "fix" those — the
distinction is the convention, and deleting a correct mark to make a report cleaner is
the same error as leaving a false one.  `thm:pic0_smooth` and `thm:pic0_proper` carry
no `\leanok` in *either* position, which is right: their statements *are* the
`sorry`-bodied declarations.
-/
import AlgebraicJacobian

open AlgebraicGeometry AlgebraicGeometry.Scheme

-- §0 The three open leaves of the headline witness, plus the two `sorry`-bodied
-- upstream theorems the assembly invokes (`Pic0.smooth`, `Pic0.proper`, §4).
-- Together these five are the whole mathematical distance between the tree and the
-- theorem; everything in §1 is `sorryAx` because of them and nothing else.
#print axioms AlgebraicGeometry.hasRationalPoint_of_curve
#print axioms AlgebraicGeometry.smoothOfRelativeDimension_genus_pic0
#print axioms AlgebraicGeometry.isAlbanese_pic0

-- The half of the former combined leaf `hasRationalPoint_and_geometricallyIntegral`
-- that turned out to be a theorem rather than a decision: geometric integrality of the
-- curve follows from the challenge hypotheses via `Smooth.geometricallyReduced`
-- (`Curve/GeometricallyReduced.lean`).  Clean here means it really is discharged, not
-- that a hypothesis was moved.
#print axioms AlgebraicGeometry.geometricallyIntegral_of_curve

-- Leaf A over an algebraically closed field, and the witness assembled without it.  The
-- FIRST of these is a genuine discharge and reads clean, which distinguishes it from leaf B's
-- and leaf C's `_of_isAlgClosed` companions: those record a distance and leak.  The SECOND
-- still leaks, and what it leaks on is measured in §0b below rather than asserted --- an
-- earlier revision of this comment claimed the residue over `k̄` was "the four ordinary
-- obligations" and was WRONG, because discharging leaf A does not remove the gate it
-- discharges: it makes `instHasPicScheme` fire instead of being assumed.
--
-- What the pair does establish, and it is the point: over `k̄` every remaining obligation is a
-- TRUE statement awaiting a proof, where the general witness also carries a FALSE one.  That
-- distinction is invisible here --- trap (c) means a witness resting on an inconsistent leaf
-- reports the same `sorryAx` as an honest one --- so it has to be established by exhibiting
-- the discharge, which is what the clean line does.
#print axioms AlgebraicGeometry.hasRationalPoint_of_curve_of_isAlgClosed
#print axioms AlgebraicGeometry.picardJacobianWitnessOfIsAlgClosed

-- Leaf B at the strength the landed development reaches: the dimension count
-- `dim T_e Pic⁰_{C/k} = genus C` holds at the headline with no transport, so what leaf B
-- still owes is `Pic0.smooth` plus the passage from a tangent-space dimension to Mathlib's
-- presentation-based `SmoothOfRelativeDimension` — which has no bridge in either direction.
-- Like leaf C's `_of_isAlgClosed` companion this reports `sorryAx`, and for the same reason:
-- it is a faithful record of a distance, not a discharge.
#print axioms AlgebraicGeometry.finrank_tangentSpace_pic0_eq_genus

-- Leaf C at the strength the landed Albanese development actually reaches.  This is a
-- theorem, so what it measures is the DISTANCE from the leaf: over an algebraically closed
-- field, in positive genus, and given the basepoint condition, the universal property is
-- `Albanese.Pic0.albanese_universal_property` on the nose.  It reports `sorryAx` all the
-- same, because `Pic0.abelJacobi` is unconstructed -- which is the honest reading: a faithful
-- record of where the mathematics stops is not a discharge.
#print axioms AlgebraicGeometry.isAlbanese_pic0_of_isAlgClosed

/-! §0b How many obligations does the witness over `k̄` actually rest on?  FIVE, not four,
and the pair below is why the answer had to be measured.

The tempting arithmetic is: five obligations, leaf A discharged over `k̄`, therefore four.
It is wrong, and the reason is trap (a) landing on the very declaration whose docstring warns
about trap (c).  `Scheme.Pic0Scheme` carries `[HasPicScheme C]` among its binders, whose sole
producer is the `sorry`-bodied `instHasPicScheme` (§2).  Over a general field that gate hides
*behind* leaf A --- the leaf is what supplies `HasRationalPoint`, from which the gate is
synthesised --- so counting it separately looks like double-counting.  Discharging leaf A does
not remove the gate; it makes the gate FIRE.  So the gate is a free-standing fifth obligation
over `k̄`, and it is the one nobody was counting.

`probe_pic0Scheme_named_of_isAlgClosed` isolates this: it discharges leaf A and then merely
*names* `Pic0Scheme C`, with no `Pic0.smooth`, no `Pic0.proper`, and neither leaf B nor leaf C
anywhere in the term.  It still reports `sorryAx`.  The control assumes the gate instead of
synthesising it and is clean, which pins the leak to synthesis and to nothing else.

The claim that survives, and it is the one worth publishing: over `k̄` all five remaining
obligations are TRUE statements awaiting proofs, where the general-field witness carries a
FALSE one among them.  "Four" was a count; the kind of obligation is the content. -/
section Section0b

open AlgebraicGeometry

universe u₀

variable {k : Type u₀} [Field k] (C : CategoryTheory.Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]

/-- Leaf A discharged, then `Pic⁰_{C/k̄}` merely named.  Leaks: the gate is synthesised. -/
noncomputable def probe_pic0Scheme_named_of_isAlgClosed [IsAlgClosed k] :
    CategoryTheory.Over (Spec (.of k)) := by
  haveI := hasRationalPoint_of_curve_of_isAlgClosed C
  haveI : GeometricallyIntegral C.hom := geometricallyIntegral_of_curve C
  exact Scheme.Pic0Scheme C

/-- The control: the same object with `HasPicScheme` assumed rather than synthesised.  Clean,
which is what isolates the leak above to the gate. -/
noncomputable def probe_pic0Scheme_named_gateAssumed [GeometricallyIntegral C.hom]
    [Scheme.HasPicScheme C] : CategoryTheory.Over (Spec (.of k)) :=
  Scheme.Pic0Scheme C

#print axioms probe_pic0Scheme_named_of_isAlgClosed
#print axioms probe_pic0Scheme_named_gateAssumed

end Section0b

/-! §0c Branch (1) of the open decision I-0372, as a compiled definition rather than a
description.

`picardJacobianWitnessOfHasRationalPoint` is the FGA assembly with `[HasRationalPoint C]` as
a binder instead of a source, and `picardJacobianWitness` /
`picardJacobianWitnessOfIsAlgClosed` are both `haveI` specialisations of it. Two things follow
that are worth having measured.

First, it *leaks* — the synthesised gate `instHasPicScheme`, `Pic0.smooth`, `Pic0.proper`, and
leaves B and C are open — and that is the honest reading of "branch (1) is cheap": cheap means
no NEW mathematics beyond those FIVE, not that a headline carrying `C(k) ≠ ∅` is available
today. The clean/leak split here says precisely which of the two.

Second, note what it does *not* measure, and that the count above is five for the reason §0b
gives. Under this binder the representability gate is *synthesised*, not assumed, so it is one
of the obligations rather than a hypothesis of the statement — the same step at which "five
becomes four" was wrongly asserted twice before. §0b's pair, not this line, is where the gate
is visible. Comparing this line against `picardJacobianWitness`
tells you nothing at all, because both leak and for overlapping reasons; the informative
comparison is §0b's. -/
#print axioms AlgebraicGeometry.picardJacobianWitnessOfHasRationalPoint

-- §1 The headline (AlgebraicJacobian/Jacobian.lean, AbelJacobi.lean)
#print axioms AlgebraicGeometry.picardJacobianWitness
#print axioms AlgebraicGeometry.nonempty_jacobianWitness
#print axioms AlgebraicGeometry.jacobianWitness
#print axioms AlgebraicGeometry.Jacobian
#print axioms AlgebraicGeometry.Jacobian.instGrpObj
#print axioms AlgebraicGeometry.Jacobian.smoothOfRelativeDimension_genus
#print axioms AlgebraicGeometry.Jacobian.instIsProper
#print axioms AlgebraicGeometry.Jacobian.instGeometricallyIrreducible
#print axioms AlgebraicGeometry.IsAlbanese
#print axioms AlgebraicGeometry.IsAlbanese.unique
#print axioms AlgebraicGeometry.Jacobian.ofCurve
#print axioms AlgebraicGeometry.Jacobian.comp_ofCurve
#print axioms AlgebraicGeometry.Jacobian.exists_unique_ofCurve_comp
#print axioms AlgebraicGeometry.genus

/-! §2 The two `sorry`-bodied INSTANCES, which are the whole of trap (a).

These two are singled out because an instance is the only kind of `sorry` carrier that a
consumer can pick up *without naming it*: every other carrier has to be written down by
whoever depends on it, whereas these arrive through synthesis. §8 measures the consequence.

The enumeration is exhaustive, and worth stating as such because "there are two" is the kind
of claim that rots silently as modules land. Measured on the rooted tree (2026-07-28), the
project declares **26 `sorry`-bodied declarations** over 11 modules, of which exactly **two
are instances** — the two below. The other 24 are theorems and definitions:

  Jacobian.lean          `hasRationalPoint_of_curve`, `smoothOfRelativeDimension_genus_pic0`,
                         `isAlbanese_pic0`                                    (the three leaves)
  IdentityComponent      `degree`, `finrank_eq_genus`, `kPoints_iff_kerDegree`
  Pic0AbelianVariety     `finrank_cotangentSpaceDual_eq_finrank_h1Cok`, `smooth`, `proper`
  AlbaneseUP             `abelJacobi`, `SymmetricPower`, `symmetricPowerAVMap`,
                         `symmetricPowerToJacobian`, `descentThroughBirationalSigma`,
                         `albanese_eq_iff_symmetricPower_eq`
  QuotFunctorDef         `Modules.pullbackTensorMap_isIso`, `gammaFiber_finrank_baseChange_field`
  SerreFiniteness        `sectionGradedModule_fg`, `gradedHilbert_fiber`
  QuotRepresentability   `QuotScheme`
  CodimOneExtension      `indeterminacy_pure_codim_one_into_grpScheme`
  WeilDivisor            `principal_degree_zero`
  CechHigherDirectImageUnconditional
                         `cech_pushforward_baseChange_natIso`, `twisted_cech_nerve_iso`
                         (two `fun _ => sorry` fields, so they are carriers even though the
                         declarations are not themselves bare `sorry` bodies)

To re-derive rather than trust that list, and to see immediately if it has drifted:

    lake build AlgebraicJacobian 2>&1 | grep 'declaration uses' | sort -u

Each line is one carrier, `file:line:col`. Which of them are instances is a source question at
those lines, not something the build reports; the two below are `noncomputable instance
instHasPicScheme` and `instance pullback_preservesFiniteLimits`. Do not derive the count by
grepping the sources for `:= sorry`: that misses the last two entries above, whose `sorry`
sits in a structure field, and it counts prose mentions of the word. Two earlier revisions of
this file got the arithmetic wrong in exactly one of those ways, which is the reason the
command is written out here rather than the number alone. -/
#print axioms AlgebraicGeometry.Scheme.instHasPicScheme
#print axioms AlgebraicGeometry.pullback_preservesFiniteLimits

-- §3 Picard cone keystones
#print axioms AlgebraicGeometry.Scheme.PicScheme
#print axioms AlgebraicGeometry.Scheme.PicScheme.representable
#print axioms AlgebraicGeometry.Scheme.PicScheme.picSharp
#print axioms AlgebraicGeometry.Scheme.Pic0Scheme

-- §4 Pic⁰-is-an-abelian-variety cone
#print axioms AlgebraicGeometry.Scheme.Pic0.tangentSpaceIso
#print axioms AlgebraicGeometry.Scheme.Pic0.smooth
#print axioms AlgebraicGeometry.Scheme.Pic0.proper
#print axioms AlgebraicGeometry.Scheme.Pic0.geometricallyIrreducible
#print axioms AlgebraicGeometry.Scheme.Pic0.grpObj
#print axioms AlgebraicGeometry.Scheme.Pic0.isAbelianVariety
#print axioms AlgebraicGeometry.Scheme.Pic0Scheme.isAbelianVariety
#print axioms AlgebraicGeometry.Scheme.Pic0.finrank_cotangentSpace_eq_finrank_hModuleOne
#print axioms AlgebraicGeometry.Scheme.Pic0.pointedDualNumberPoints_equiv_relPicKernel
#print axioms AlgebraicGeometry.Scheme.Pic0.isSeparated
#print axioms AlgebraicGeometry.Scheme.Pic0.locallyOfFiniteType

-- §5 Cohomology cone: the Čech engine and the flat-base-change frontier
#print axioms AlgebraicGeometry.cech_computes_higherDirectImage
#print axioms AlgebraicGeometry.pullback_preservesFiniteColimits
#print axioms AlgebraicGeometry.pullback_preservesHomology
#print axioms AlgebraicGeometry.Scheme.subsingleton_hModule'_one_toModuleKSheaf_of_isAffineOpen

-- §6 Riemann–Roch / genus cone
#print axioms AlgebraicGeometry.Adelic.instModuleFiniteHModuleOne
#print axioms AlgebraicGeometry.Scheme.AffineCoverMVSquare.hModuleOneEquivH1Cok_curve
#print axioms AlgebraicGeometry.Scheme.AffineCoverMVSquare.chi_unit_eq_one_sub_genus
#print axioms AlgebraicGeometry.Scheme.AffineCoverMVSquare.h1_unit_eq_genus

/-! §2b The SEVENTH trap, and the one that is hardest to defend against: a hypothesis the
project can REFUTE.

Trap (c) below is a named hypothesis that is false as stated — someone has to notice that it
is false. This is the sharper version: a hypothesis whose negation is *derivable from
declarations already in the tree*, so the project simultaneously proves `H → C` and, at every
instance anyone would use, `¬H`. The theorem is true, axiom-clean, non-vacuous by every probe
in this file, and empty.

Measured instance (2026-07-28, `RiemannRoch/Adelic/LedgerClosure.lean`): `chi_eq_of_bump`
takes `hbump : ∀ P E, χ(1·P + E) = χ(E) + residueDeg P`. Iterating it down the anti-effective
cone forces `χ(-m·P) = χ(0) - m·[κ(P):k]`, and since `χ = ℓ - h¹` with `ℓ ≥ 0`, `h¹` must grow
linearly there. So `hbump` is FALSE on every cover whose `h¹` is bounded — and outright false
at the degenerate cover `U₀ = U₁ = ⊤`, where the Čech `H¹` vanishes identically, as soon as a
single prime divisor exists. That refutation needs no exactness data at all.

THE OFF-CHART REFUTATION, and the two-step history of this paragraph is the most instructive
part of the entry, because the trap caught the audit and then caught the retraction.

Round 1 (the audit, `I-0449`): a second refutation "at each prime outside the overlap", on the
grounds that `A(1·P + E) = A(E)` there makes the local step a subsingleton, so
`ChiLedger.chi_add` gives a χ-jump of `0` against `hbump`'s `residueDeg P ≥ 1`.

Round 2 (my retraction, and it was WRONG): I withdrew that on the grounds that the derivation
runs through `chi_add`, so it measures `chi_add`'s exactness hypotheses rather than `hbump` —
citing `Adelic.bump_iff_chartStep_of_notMem_left`, which makes `hbump` at such a `P` equivalent
to the surviving one-chart step being `[κ(P):k]`, and concluding `hbump` is merely weaker there
rather than false.

Round 3 (`I-0467`, machine-checked, and it reinstates round 1): the one-chart step cannot be
`[κ(P):k]` repeatedly, because the overlap term `A` is FROZEN along the tower `n·P`
(`sectionSub_add_pointDivisor_of_notMem`, iterated) and the coboundary term is trapped beneath
it (`S₁(D) ≤ A(D)`). So in `χ = dim S₀ + dim S₁ − dim A` all three terms are bounded along the
tower while `hbump` forces linear growth. Hence `¬hbump` off the chart, from this file's own
theorems and its own finiteness binders, with **no** `chi_add` and no exactness hypothesis
anywhere. The equivalence I cited is true and does not say what I used it for: its right-hand
side is itself false for large `n`. `Adelic.not_bump_of_notMem_left` and
`Adelic.ledger_refuted_of_notMem_left` are the landed forms (§6f), and `P.point ∉ U₀` is far
weaker than `P.point ∉ U₀ ⊓ U₁`, so the refutation reaches MORE primes than the audit claimed.

Honest status of `hbump`: consistent (`bump_of_isEmpty_primeDivisor`); refutable at
`U₀ = U₁ = ⊤` given one prime divisor; refutable on every bounded-`h¹` cover; refutable
whenever any prime divisor lies off one chart; satisfiable only where `h¹` is unbounded on the
anti-effective cone. The closed ledger itself is refuted on the same covers. None of that
contradicts the vanishing lane, whose results are high-degree only — which is why nobody
noticed.

The generalisable lesson, and note that it cuts BOTH ways, which is what round 2 missed. When a
hypothesis `H` and a lemma `L` are inconsistent together, that does not tell you which is at
fault: establishing that `H` is refutable requires deriving `¬H` from things THEMSELVES
satisfiable. That is why round 1's argument was not yet conclusive. But it equally does not
license concluding `H` is *fine* — round 2 inferred "not refutable" from "not refutable by this
route", which is the same error with the sign flipped, and an ungated derivation existed the
whole time. The correct response to "your refutation measured the wrong thing" is to look for an
ungated derivation, not to withdraw the conclusion. Recorded as I-0449/I-0454/I-0467, with the
durable lessons at I-0451 and I-0468.

What defeats each check, in order: `#print axioms` sees a clean line; a consistency witness
exists (`bump_of_isEmpty_primeDivisor`, on a scheme with no prime divisors); an elaboration
probe synthesises every binder; and non-vacuity in the trap-(c) sense holds, because the
hypothesis is not contradictory — it is merely refutable where it is wanted. The only check
that finds it is reading the PRODUCER's side conditions and asking whether the family the
hypothesis quantifies over contains members where the tree proves the negation.

So the discipline this adds to the other six: for a hypothesis quantified over a family, do
not stop at "is it satisfiable". Ask where the project can derive its negation. Recorded as
I-0449/I-0454 with the machine-checked steps, and as the durable lesson I-0451.

§2c The EIGHTH, found in the same audit and cheaper to check than any of the others: a
hypothesis EQUIVALENT to the conclusion it is supposed to buy.

`chi_eq_of_bump` proves `hbump → closed χ-ledger`. The converse is three lines —
`rw [hledger (pointDivisor P + E), hledger E, degK_add, degK_pointDivisor]; ring` — because
`degK` is an `AddMonoidHom` and the bump adds exactly one point. A theorem `A → B` whose
converse is trivial transports no information: it is a restatement, and "is `A` satisfiable"
is literally the question "is `B` satisfiable". The theorem is true, axiom-clean,
instantiable, non-vacuous, and not a reduction.

This is the re-indexing failure mode one level out, and it is the one to check FIRST, because
it costs a single `rw` attempt: before believing that `H → C` reduces `C` to `H`, try to prove
`C → H`. If that succeeds, no amount of axiom-probing will tell you the result is empty.
Lesson recorded as I-0456.

§6b Cluster-P extensions (task ajc-rr).  Independent re-verification, in the
rooted environment, of the axiom claims made in I-0383 and I-0403.

CAUTION, and this is the section to read before quoting any line below as a
completeness claim: several of these are axiom-clean and still NOT unconditional
mathematics, because they take the closed χ-ledger and/or a peel-surjectivity
datum as *named hypotheses* — invisible to `#print axioms`.  What each one is
open in, as of 2026-07-27:

| declaration                          | open named hypotheses                    |
|--------------------------------------|------------------------------------------|
| `chi_eq_of_linearEquivalence`        | none (unconditional)                     |
| `degK`                               | none (a definition)                      |
| `degK_principal_eq_zero`             | none (unconditional)                     |
| `ell_eq_zero_of_degK_neg`            | closed χ-ledger                          |
| `chi_divisorOfList_eq_degK`          | closed χ-ledger                          |
| `coneVanishing_iff_base_and_peel`    | none (unconditional; an equivalence)     |
| `exists_bound_subsingleton_h1Mod`    | base vanishing at one divisor + peel     |
| `exists_bound_subsingleton_h1Mod_of_pointPeel` | base vanishing + point-peel    |
| `exists_bound_h1dim_eq_zero`         | the above, plus the closed χ-ledger      |

The honest one-line summary of the vanishing lane, in ajc-rr's own sharpened
words: single-field bounded `H¹` vanishing is assembled and kernel-checked, and
its hypothesis pair (base vanishing at one divisor plus peel-surjectivity) is
*equivalent* to vanishing on the whole cone `{D' ≥ D₀}` — that equivalence is
proved (`coneVanishing_iff_base_and_peel`).  So the content is "pointwise cone
vanishing plus closed ledger ⟹ numerical-degree vanishing", a real reduction,
since a divisor of large weighted degree need not dominate `D₀`.  It is NOT "one
vanishing implies all vanishing".  Extension-uniformity and global generation are
proved nowhere in AJC, and extension-uniformity is not currently even statable:
the invariants are pinned to a chosen 2-affine cover and `CurveBaseChange.lean`
does not transport it.

One further caveat that no axiom line shows.  "`Subsingleton` rather than
`h¹ = 0`, so no finiteness instance is needed" holds only for the
vanishing-criterion and peel machinery.  Any theorem taking the closed χ-ledger
carries finiteness content with no `Module.Finite` binder visible, because
`Module.finrank` of an infinite-dimensional space is `0`. -/
#print axioms AlgebraicGeometry.Adelic.chi_eq_of_linearEquivalence
#print axioms AlgebraicGeometry.Adelic.degK
#print axioms AlgebraicGeometry.Adelic.degK_principal_eq_zero
#print axioms AlgebraicGeometry.Adelic.ell_eq_zero_of_degK_neg
#print axioms AlgebraicGeometry.Adelic.exists_bound_h1dim_eq_zero
#print axioms AlgebraicGeometry.Adelic.exists_bound_subsingleton_h1Mod
#print axioms AlgebraicGeometry.Adelic.coneVanishing_iff_base_and_peel
#print axioms AlgebraicGeometry.Adelic.exists_bound_subsingleton_h1Mod_of_pointPeel
#print axioms AlgebraicGeometry.Adelic.chi_divisorOfList_eq_degK

/-! §6d The global-generation and ledger-closure lane (task ajc-rr, requested in I-0410).

Same caution as §6b, and ajc-rr asked for it to be kept: everything in the generation
lane takes the closed χ-ledger `hledger` as an explicit hypothesis, so a clean axiom line
on `exists_bound_generatedAt` says nothing about the ledger being available.  Measured
open named hypotheses, read off the signatures rather than asserted:

| declaration                                    | open named hypotheses                   |
|------------------------------------------------|-----------------------------------------|
| `evalMap_injective`                            | none (unconditional)                    |
| `mem_orderGe_one_iff_mem_maximalIdeal`         | none (unconditional)                    |
| `residueDeg_eq_one_iff_hasRationalResidues`    | none (unconditional; an equivalence)    |
| `hasRationalResidues_of_isAlgClosed`           | no *named* hypothesis, but three
                                                   un-instantiable instance binders —
                                                   see §6e, this is trap (d)              |
| `residueDeg_eq_one_of_hasRationalResidues`     | rational residues at every point        |
| `degK_eq_degree_of_hasRationalResidues`        | rational residues at every point        |
| `ell_sub_ell_sub_pointDivisor_eq`              | ledger + vanishing at `D` and `D − P`   |
| `evalMap_surjective`                           | ledger + the same two vanishings        |
| `generatedAt_of_evalMap_surjective`            | surjectivity of `evalMap` itself        |
| `generatedAt_of_vanishing`                     | ledger + the same two vanishings        |
| `exists_bound_generatedAt`                     | ledger + base vanishing + peel          |
| `exists_bound_forall_generatedAt`              | the above, plus a uniform residue bound |
| `exists_bound_forall_generatedAt_of_hasRationalResidues` | ledger + base vanishing + peel |
| `degree_principal_eq_zero_of_hasRationalResidues` | ledger + rational residues          |
| `chi_eq_of_bump_of_nonneg`                     | the one-point bump                      |
| `chi_eq_iff_step_of_bump`                      | the one-point bump (an equivalence)     |

§6e The fourth trap, and why the apparent exception in the table above is not one.

`hasRationalResidues_of_isAlgClosed` looks like the one unconditional statement of the
lane: no ledger, no vanishing, no bump, and it measures clean.  It is not, and the reason
is a way of overstating a result that the other three traps do not cover.

Its obligations are in *instance* position, not in named-hypothesis position:
`[Algebra k (X.presheaf.stalk P.point)]`,
`[IsScalarTower k (X.presheaf.stalk P.point) X.functionField]` and
`[Module.Finite k (IsLocalRing.ResidueField (X.presheaf.stalk P.point))]`.  Nothing in
this project constructs any of the last two for the ambient object the Adelic lane runs
on — a bare `Scheme X` — and the first exists only for `Over (Spec k)` objects.  The
`Module.Finite` binder is on the stalk residue field, which the lane has no identification
with its own `localStepTgt` keystone, so it is a new obligation rather than a reused one.

So the fourth trap, in the same form as the other three:

  (d) a theorem whose INSTANCE BINDERS are never instantiable for the object actually
      used reports `[propext, Classical.choice, Quot.sound]` and always will, because the
      binders are hypotheses.  The axiom output cannot see this at all; the check is
      whether each binder has a constructing instance for the ambient object.

The statement is still a real reduction — `[κ(P) : k] = 1` is traded for standard stalk
commutative algebra — but it is a relocation of the obligation, not a discharge, and the
two `_of_hasRationalResidues` results are therefore not unconditional over an
algebraically closed field either.

RESOLVED, and the resolution is what makes trap (d) worth stating rather than merely
embarrassing.  `RiemannRoch/Adelic/ResidueField.lean` supplies the `_curve` forms below,
which take no stalk binders at all: only the curve's own geometric instances, with the
stalk algebra and tower *built* (`algebraMap_stalk_functionField`,
`isScalarTower_stalk_functionField`) and the residue-field finiteness routed around
entirely through mathlib's `residueFieldIsoBase`, which gets integrality of `κ(x)` over `k`
from `LocallyOfFiniteType` by the Jacobson-space criterion.  So the same mathematics that
was a relocation in the `_of_hasRationalResidues` form is a discharge in the `_curve` form,
and the difference is invisible to `#print axioms`: both report clean.  That is trap (d)
stated positively — the axiom line was never the thing that distinguished them.

`degK_eq_degree_of_isAlgClosed_curve` is the one to look at: geometric degree equals the
residue-weighted degree on an AJC curve over an algebraically closed field, with no open
input at all.  `degree_principal_eq_zero_of_isAlgClosed_curve` then rests on the closed
ledger alone, where its `_of_hasRationalResidues` predecessor needed the ledger *and* the
approximation statement.

ONE QUALIFICATION, established by elaborating a consumer rather than by reading signatures,
because that is the discipline trap (d) demands.  These take an `Adelic.IsConstantField k
C.left` binder whose producer (`Scheme.instIsConstantField`, `Adelic/GateInstances.lean`) is
a `scoped` instance.  A consumer must therefore `open scoped AlgebraicGeometry.Scheme`; a
`degK_eq_degree_of_isAlgClosed_curve` applied without it fails to synthesize, and the
failure looks exactly like trap (d) even though the instance exists.  Instantiability is
`open`-sensitive, which is a fifth thing no axiom line shows and the reason to test the
consumer instead of the signature. -/
#print axioms AlgebraicGeometry.Adelic.evalMap_injective
#print axioms AlgebraicGeometry.Adelic.mem_orderGe_one_iff_mem_maximalIdeal
#print axioms AlgebraicGeometry.Adelic.residueDeg_eq_one_iff_hasRationalResidues
#print axioms AlgebraicGeometry.Adelic.hasRationalResidues_of_isAlgClosed
#print axioms AlgebraicGeometry.Adelic.residueDeg_eq_one_of_hasRationalResidues
#print axioms AlgebraicGeometry.Adelic.degK_eq_degree_of_hasRationalResidues
#print axioms AlgebraicGeometry.Adelic.ell_sub_ell_sub_pointDivisor_eq
#print axioms AlgebraicGeometry.Adelic.evalMap_surjective
#print axioms AlgebraicGeometry.Adelic.generatedAt_of_evalMap_surjective
#print axioms AlgebraicGeometry.Adelic.generatedAt_of_vanishing
#print axioms AlgebraicGeometry.Adelic.exists_bound_generatedAt
#print axioms AlgebraicGeometry.Adelic.exists_bound_forall_generatedAt
#print axioms AlgebraicGeometry.Adelic.exists_bound_forall_generatedAt_of_hasRationalResidues
#print axioms AlgebraicGeometry.Adelic.degree_principal_eq_zero_of_hasRationalResidues
#print axioms AlgebraicGeometry.Adelic.chi_eq_of_bump_of_nonneg
#print axioms AlgebraicGeometry.Adelic.chi_eq_iff_step_of_bump

-- The `_curve` forms of §6e: same clean axiom lines as their `_of_hasRationalResidues`
-- predecessors, and unlike them, instantiable at the curve's own hypotheses.
#print axioms AlgebraicGeometry.Adelic.algebraMap_stalk_functionField
#print axioms AlgebraicGeometry.Adelic.isScalarTower_stalk_functionField
#print axioms AlgebraicGeometry.Adelic.hasRationalResidues_of_isAlgClosed_curve
#print axioms AlgebraicGeometry.Adelic.residueDeg_eq_one_of_isAlgClosed_curve
#print axioms AlgebraicGeometry.Adelic.degK_eq_degree_of_isAlgClosed_curve
#print axioms AlgebraicGeometry.Adelic.degree_principal_eq_zero_of_isAlgClosed_curve
#print axioms AlgebraicGeometry.Adelic.exists_bound_forall_generatedAt_of_isAlgClosed_curve

/-! §6f The unconditional-χ lane, measured THROUGH THE ROOT PATH (requested by ajc-rr in
I-0463).

ajc-rr measured twelve declarations in their own session and reported zero `sorryAx`, but
flagged the measurement themselves: they probed through a scratch file that imported
`AlgebraicJacobian` *plus* the two new modules directly, because at that moment
`ChiUnconditional` and `UniformChartVanishing` were committed and **not** in the root
roll-up. The two imports have since landed (`AlgebraicJacobian.lean`), so the lines below
are measured on the root path — the measurement that may be quoted. All clean, agreeing with
theirs.

Ten of the twelve, not twelve: `degK_principal_eq_zero_of_chartCounts` and
`chartCountsDegree_iff_ledger` no longer exist. ajc-rr deleted them (audit `I-0467`) on their
own initiative, for two reasons worth recording because both are the reasons a probe line
would have been misleading. The predicate was `Iff.rfl` to the closed ledger and
`SectionBounds.degK_principal_eq_zero` already took that hypothesis verbatim, so the theorem
was the old one with a renamed binder; and it was *vacuous on the covers the module is about*,
since the ledger is outright FALSE whenever a prime divisor lies off one chart. Two clean
axiom lines would have sat on a duplicate of a vacuous statement — which is trap (c) and trap
(h) at once, and no axiom output distinguishes either. `ledger_refuted_of_notMem_left` below
is what replaced them, and it is a constraint on the route rather than a theorem about it.

This is also why a probe file must be re-elaborated and not merely re-read after a sibling
team lands: naming a deleted declaration is a hard error, so the file itself fails rather than
silently reporting a stale set. That is the desired failure mode, and it fired here.

Why the distinction is not pedantry. An unrooted module is invisible to `import
AlgebraicJacobian`, so its axioms cannot be probed here at all; and a scratch import can
differ from the root path in instance *scope*, which §6e's final qualification shows is
exactly the kind of difference an axiom line does not display. The honest procedure when a
sibling team lands a module is: root it, rebuild, then re-measure — not carry the scratch
number forward.

What the clean lines do and do not say. Same caution as §6b and §6d: the χ identity
`chi_eq_charts_sub_overlap` is genuinely unconditional (inclusion–exclusion for a two-set
cover, no exact sequence and no exactness binders), whereas the two vanishing statements carry
chart-count hypotheses proved at no curve. `uniformlyBoundedVanishing_of_uniformChartCount`
takes `UniformChartCount`, which is strictly stronger than the single-field count. And the two
refutations are the sharpest lines here precisely because they are *negative*: they say the
bump hypothesis and the closed ledger are FALSE on any cover having a prime divisor off one
chart, so a clean axiom line on anything downstream of either is clean about a vacuous
premise (trap (h)). -/
#print axioms AlgebraicGeometry.Adelic.chi_eq_charts_sub_overlap
#print axioms AlgebraicGeometry.Adelic.chi_sub_chi_eq_charts_sub_overlap
#print axioms AlgebraicGeometry.Adelic.sectionSub_top_eq_inf
#print axioms AlgebraicGeometry.Adelic.sectionSub_add_pointDivisor_of_notMem
#print axioms AlgebraicGeometry.Adelic.chi_add_pointDivisor_of_notMem_left
#print axioms AlgebraicGeometry.Adelic.bump_iff_chartStep_of_notMem_left
#print axioms AlgebraicGeometry.Adelic.charts_sub_overlap_le_ell
#print axioms AlgebraicGeometry.Adelic.h1dim_eq_zero_iff_charts
#print axioms AlgebraicGeometry.Adelic.exists_bound_h1dim_eq_zero_of_charts
#print axioms AlgebraicGeometry.Adelic.uniformlyBoundedVanishing_of_uniformChartCount

-- The two refutations that replaced the deleted `ChartCountsDegree` pair.  Both are
-- unconditional negative results on a cover with a prime divisor off one chart.
#print axioms AlgebraicGeometry.Adelic.not_bump_of_notMem_left
#print axioms AlgebraicGeometry.Adelic.ledger_refuted_of_notMem_left

-- §6c The rigid-pushforward gate (task ajc-gate).  THE GATE IS NOW INSTANTIATED AND THE
-- INSTANCE IS AXIOM-CLEAN — `instHasRigidPushforwardOfCurve`
-- (`Picard/RigidPushforwardGammaBaseChange.lean`), for every AJC curve, with no hypothesis
-- beyond the curve's own.  This is the one case in this file where a global instance is
-- *good* news, and it is exactly the case where the measurement matters most: the whole
-- point of §8 below is that a `sorry`-bodied instance poisons every synthesis site, so an
-- instance that measures clean has to be checked, not assumed.  The three extraction
-- theorems of `Picard/RigidPushforward.lean` now synthesize their gate rather than
-- assuming it, and §6c-headlines below measures them at that synthesis site.
--
-- `hasRigidPushforward_of_leaves` is a four-leaf FACTORIZATION, of historical interest
-- only now that the gate is a theorem; it was never the frontier once two of its leaves
-- were proved.
--
-- THIRD TRAP, worse than the first two, demonstrated in this very cone (I-0395): a
-- theorem whose named hypothesis is FALSE is vacuously true, and reports clean axioms
-- like any other.  `hrank`, one of the gate's extracted leaves, quantifies over every
-- finitely presented module with no flatness or fibrewise-vanishing hypothesis, and is
-- refuted by `𝒪_{ℙ¹_A}/x` (rank 0 against fibre `h⁰ = 1`).  So the assembly theorems
-- above it are clean, true, and empty.  `#print axioms` sees none of this.  It answers
-- exactly one question — "is a `sorry` reachable from this proof term" — and four
-- separate things it cannot see have now been measured here:
--   (a) a sorry-bodied INSTANCE reached only at a synthesis site (§8);
--   (b) a named hypothesis in the STATEMENT that is unproved (§6b);
--   (c) a named hypothesis in the statement that is FALSE (§6c);
--   (d) an INSTANCE BINDER that nothing can instantiate for the ambient object (§6e).
-- A fifth, outside this file: an unrooted module cannot be probed at all, because
-- `import AlgebraicJacobian` does not reach it (companion measurement 2 in the header).
#print axioms AlgebraicGeometry.Adelic.hasRigidPushforward_of_leaves

-- The gate's state after `Picard/RigidPushforwardInstance.lean`.  Two of the three
-- statements the frontier file listed are now theorems and this is where that is
-- measured rather than taken on report: `instIsIntegralP1OverLeft` (from the chart-ring
-- identification `Γ(ℙ¹_k, D₊(Xᵢ)) ≃ₐ[k] k[T]` plus the two-chart irreducibility
-- argument) and `p1RankIdentity_proved` carry no named hypotheses at all, so a clean
-- line on them is an unconditional discharge in the §6d sense.  The two consequences
-- are clean and conditional in the *other* direction: they quantify over the curve's
-- own instances only, which for an AJC curve are synthesized.
--
-- `hasRigidPushforward_of_gammaBaseChange` was the honest residue when the gate's cost was
-- one statement; `rigidPushforwardGammaBaseChange_proved` now supplies that statement, so
-- the reduction closed rather than merely narrowing.  Both are measured, along with the
-- resulting instance and the three extraction theorems AT THEIR SYNTHESIS SITE — which is
-- the only measurement that distinguishes a real discharge from trap (a).
#print axioms AlgebraicGeometry.Adelic.instIsIntegralP1OverLeft
#print axioms AlgebraicGeometry.Adelic.p1RankIdentity_proved
#print axioms AlgebraicGeometry.Adelic.p1RigidPushforwardStatement_proved
#print axioms AlgebraicGeometry.Adelic.rigidPushforwardLocallyFree_proved
#print axioms AlgebraicGeometry.Adelic.hasRigidPushforward_of_gammaBaseChange
#print axioms AlgebraicGeometry.Adelic.p1ChartSectionsAlgEquivX
#print axioms AlgebraicGeometry.Adelic.isIntegral_p1_of_isDomain_charts

-- The statement that closed the reduction, the instance it produces, and the three
-- extraction theorems restated without the gate binder — so they are measured where the
-- gate is SYNTHESIZED, not where it is assumed.  Compare §8: the same measurement on
-- `HasPicScheme` is what exposes `instHasPicScheme`, and these come out the other way.
#print axioms AlgebraicGeometry.Adelic.rigidPushforwardGammaBaseChange_proved
#print axioms AlgebraicGeometry.Adelic.instHasRigidPushforwardOfCurve
#print axioms AlgebraicGeometry.Adelic.rigidPushforward_locallyFree
#print axioms AlgebraicGeometry.Adelic.rigidPushforward_baseChange
#print axioms AlgebraicGeometry.Adelic.rigidPushforward_isLocallyTrivial

-- NON-VACUITY of that instance, which trap (c) says is a separate question from cleanliness:
-- a theorem quantified over three hypotheses is worth nothing if the tree contains nothing
-- satisfying them, and a vacuous theorem reports clean axioms like any other.  `ℙ¹` over an
-- arbitrary field satisfies all three and the gate fires at it, so the discharge above is
-- not empty.  This is the measurement that `hrank` (the false-hypothesis case) would fail.
#print axioms AlgebraicGeometry.Adelic.hasRigidPushforward_p1Over
#print axioms AlgebraicGeometry.Adelic.instSmoothOfRelativeDimensionOneP1Over
#print axioms AlgebraicGeometry.Adelic.rigidPushforward_baseChange_p1Over

-- The gate at the *challenge's own* hypothesis bundle, which is the form the headline would
-- consume: `GeometricallyIrreducible` where the gate's producer wants `GeometricallyIntegral`.
-- Measuring it here is not redundant with `instHasRigidPushforwardOfCurve` above, because the
-- two differ exactly by the `Smooth ⇒ GeometricallyIntegral` upgrade of
-- `Curve/GeometricallyReduced.lean` — the same upgrade the headline's
-- `geometricallyIntegral_of_curve` performs.  A clean line here says the gate is available at
-- the hypotheses of `Jacobian C` itself, not merely at a restatement of them.
#print axioms AlgebraicGeometry.Adelic.hasRigidPushforward_of_geometricallyIrreducible

-- §7 Albanese cone
#print axioms AlgebraicGeometry.Pic0.bundle
#print axioms AlgebraicGeometry.Pic0.jacobianScheme
#print axioms AlgebraicGeometry.Pic0.abelJacobi
#print axioms AlgebraicGeometry.Pic0.albanese_universal_property
#print axioms AlgebraicGeometry.Pic0.descentThroughBirationalSigma
#print axioms AlgebraicGeometry.Scheme.RationalMap.extend_to_av

/-! §8 The synthesis leak, measured rather than assumed.

A `#print axioms` on a declaration that *quantifies over* `[HasPicScheme C]`
reports the axioms of the declaration only, because the hypothesis is discharged
by the caller.  The leak the audit is about happens one step later: at a call
site where Lean must **synthesise** the instance, and the only producer is the
`sorry`-bodied `instHasPicScheme`.  The two `example`s below force exactly that
synthesis, so their axiom sets measure what a consumer of the theorem actually
gets.  `Flat` likewise has honest producers, so the flat-pullback probe is
stated at an identity morphism, whose flatness is proved. -/

namespace AlgebraicGeometry

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory Scheme

universe u

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom]

/-- Instantiated at a curve with a rational point, `Pic0.geometricallyIrreducible`
has to synthesise `HasPicScheme C`, whose sole producer is `sorry`-bodied. -/
theorem leakProbe_pic0_geometricallyIrreducible [HasRationalPoint C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    GeometricallyIrreducible (Pic0Scheme C).hom :=
  Pic0.geometricallyIrreducible C

/-- The same measurement for the separatedness carrier. -/
theorem leakProbe_pic0_isSeparated [HasRationalPoint C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    IsSeparated (Pic0Scheme C).hom :=
  Pic0.isSeparated C

/-- Same measurement for the local-finiteness carrier. -/
theorem leakProbe_pic0_locallyOfFiniteType [HasRationalPoint C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    LocallyOfFiniteType (Pic0Scheme C).hom :=
  Pic0.locallyOfFiniteType C

/-- The control that isolates the leak to synthesis and nothing else: identical
conclusion and proof term, but with `HasPicScheme` taken as a hypothesis rather
than synthesised.  This one is clean, which is exactly the point. -/
theorem leakControl_pic0_locallyOfFiniteType [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    LocallyOfFiniteType (Pic0Scheme C).hom :=
  Pic0.locallyOfFiniteType C

/-- The two *chapter keystones* at a synthesis site, which is what decides whether
a blueprint `\leanok` on them would be honest.  `PicScheme.representable` is
`Classical.choice` over the gate, and `Pic0.isAbelianVariety` bundles the
`sorry`-bodied `smooth` and `proper` conjuncts, so both pick up `sorryAx` here even
though each reports clean as stated. -/
noncomputable def leakProbe_picScheme_representable [HasRationalPoint C] :
    (PicScheme.picSharp C).RepresentableBy (PicScheme C) :=
  PicScheme.representable C

/-- Companion measurement for the abelian-variety assembly. -/
theorem leakProbe_pic0_isAbelianVariety [HasRationalPoint C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    IsProper (Pic0Scheme C).hom ∧ Smooth (Pic0Scheme C).hom ∧
      GeometricallyIrreducible (Pic0Scheme C).hom ∧
      Nonempty (GrpObj (Pic0Scheme C)) :=
  Pic0.isAbelianVariety C

/-- The two FGA *chapter* carriers that a blueprint `\leanok` is most likely to be read off:
the representability identification and the group-scheme structure.  Both are proved and
report clean **as stated**, and both pick up `sorryAx` here, where the gate is synthesised
rather than assumed.  This is the measurement that decides whether
`thm:fga_pic_representability`, `def:pic_scheme`, `def:inst_pic_sharp_representable` and
`thm:pic_is_group_scheme` may be read as "the Picard scheme exists in this development".
They may not: what is formalised is the extraction *from* the gate. -/
theorem leakProbe_instPicSharpRepresentable [HasRationalPoint C] :
    PicScheme.PicSharpRepresentable C :=
  inferInstance

/-- Companion measurement for the group-scheme structure.  `Nonempty` rather than the bare
class, so that this is a `theorem`: a `def` of class type draws a `@[reducible]` warning, and
a probe should not add a warning to the build it is measuring. -/
theorem leakProbe_groupSchemeStructure [HasRationalPoint C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    Nonempty (CommGrpObj (PicScheme C)) :=
  ⟨PicScheme.groupSchemeStructure C⟩

#print axioms leakProbe_pic0_geometricallyIrreducible
#print axioms leakProbe_pic0_isSeparated
#print axioms leakProbe_pic0_locallyOfFiniteType
#print axioms leakControl_pic0_locallyOfFiniteType
#print axioms leakProbe_picScheme_representable
#print axioms leakProbe_pic0_isAbelianVariety
#print axioms leakProbe_instPicSharpRepresentable
#print axioms leakProbe_groupSchemeStructure

/-- Flat pullback along the identity: `Flat` is synthesised from a proved
instance, but `PreservesFiniteLimits` still routes through the `sorry`-bodied
`pullback_preservesFiniteLimits`. -/
theorem leakProbe_pullback_finiteLimits (S : Scheme.{u}) :
    PreservesFiniteLimits (Scheme.Modules.pullback (𝟙 S)) :=
  inferInstance

#print axioms leakProbe_pullback_finiteLimits

end AlgebraicGeometry
