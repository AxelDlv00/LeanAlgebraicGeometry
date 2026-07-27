Still working, but item 1 is complete. Here it is.

**Present-tense Quot-route framing left in `blueprint/src/`** (all paths under `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/`):

Definitely stale — inside the very chapter that was re-aimed, downstream of the corrected §`sec:fga_pic_setup`:

- `blueprint/src/chapters/Picard_FGAPicRepresentability.tex:817-834`, §"The Picard-scheme existence theorem". Describes how the open gate *will be* discharged, entirely by the quotient route: "the proof first applies Kleiman §2, Thm. 2.5 … and then uses Kleiman's four steps … Hilbert-polynomial stratification, m-regularity bound, Abel-map factorisation, and the smooth-proper quotient. Its inputs are the Quot/Hilbert construction of `chap:Picard_QuotScheme` … and Altman–Kleiman effective descent."
- `Picard_FGAPicRepresentability.tex:732-737` — the `proof` body of `def:inst_has_pic_scheme`, i.e. the live gate's own node: "Apply the FGA representability construction … the bounded Hilbert-polynomial strata glue to the required locally finite type representing scheme." This is the single highest-leverage line in the file: a reader checking the open obligation reads only this.
- `Picard_FGAPicRepresentability.tex:875-884`, §"Assembly of the inputs": "The FGA construction consumes the relative-divisor functor and Abel map, then applies the regularity, base-change, and effective-quotient results."

Chapter intros / cross-references elsewhere:

- `Picard_QuotScheme.tex:5-12` (chapter STRATEGY NOTE) — "The Quot functor **underlies** the relative Picard functor via the Hilbert scheme". Present tense, and it is the first thing in the retained chapter.
- `Picard_QuotScheme.tex:8398-8406` (§"Dependencies summary") — "The Picard construction in `chap:Picard_FGAPicRepresentability` **applies** `thm:quot_representable` … giving the Hilbert scheme … and its open subscheme `Div_{C/k}`."
- `RiemannRoch_Adelic.tex:2057` — uniform H¹ vanishing described as "the curve-level replacement for Castelnuovo–Mumford boundedness **in the Quot endgame**". Wrong consumer named: this is cluster-P input to the committed route.
- `Picard_RelPicFunctor.tex:1316-1320` — "the Grothendieck–Mumford–Kleiman existence theorem **is the next step**". Arguably fine (route-neutral naming), but it is the last forward-pointer still aimed at the quotient construction.

Top-level structure file: `blueprint/src/content.tex` is a bare 34-line `\input` list, and `web.tex`/`print.tex` carry no prose. There is no chapter or preamble stating the strategy, so the blueprint's only representability narrative is the off-path one — the three FGA-chapter spots above are load-bearing precisely because nothing overrides them. Related: none of the committed route's landed Lean (`Picard/RigidPushforward.lean`, `Picard/GaloisDescent/SemilinearModules.lean`, `Picard/FiniteGaloisQuotient{,Affine}.lean`, `Picard/StableAffineCover.lean`, `Picard/RigidifiedPic.lean`, `Picard/SectionRingUniversal.lean`, `Picard/StructureSheafPushforward.lean`, `Picard/DivDegree.lean`) appears in any `% archon:covers` line — 79 files are covered, none of these.

One correctness item adjacent to this, since it is the stated justification for the whole rational-point framing: `AlgebraicJacobian/Picard/FGAPicRepresentability.lean:33-34` and `blueprint/src/chapters/Picard_RelPicFunctor.tex:945` both assert Mathlib has no étale topology on schemes. False at the pinned revision — `.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Sites/Etale.lean:32-51` defines `etalePrecoverage`, `etalePretopology`, `etaleTopology`.

On item 2: taking the two-position convention as given, I found nothing to report — no proof-level `\leanok` sits over a sorry-bodied declaration in the nodes I checked (`thm:pic0_smooth`, `thm:pic0_proper`, all seven Jacobian-chapter nodes, `thm:fga_pic_representability`, `def:inst_has_pic_scheme`, `thm:quot_representable`, `lem:pullback_preserves_finite_limits`, `lem:milne_codim1_indeterminacy`, the four `Picard_QuotScheme` leaves, both `IdentityComponent` sorry-pinned theorems). Consistent with your 1553-pin sweep. Item 5 I am dropping per your note.
