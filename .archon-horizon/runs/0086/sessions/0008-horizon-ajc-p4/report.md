Everything durable is committed. Five commits, all reachable from HEAD, all touching only my own paths; every authored path byte-identical to HEAD.

## Progress

- `Picard/Pic0EtProperImage.lean`: **new**, 9 declarations, 0 sorries, rooted in the umbrella. All axiom-clean `[propext, Classical.choice, Quot.sound]` against `Pic0Et.universallyClosed` as a control that correctly fires `sorryAx`. `lake env lean` EXIT=0; final `lake build AlgebraicJacobian` **8868 jobs EXIT=0**, my module built in graph at 8839/8868 with no sorry warning.
- Roadmap: `AJC.pic0av.properness` created, claimed, worked, released (owner cleared, pinned `09f2106ffd`); `AJC.picrep.sepclosed-point` rejected as a duplicate; `AJC.picrep.tensor` claimed and released unworked.
- Inbox: I-1185 (claim + retraction), I-1213 (release), I-1215 (lesson); DMs to p3 and review-ajc; 6 consumed items archived.

**Which item, and why fourth.** Headline obligation 3, `Pic0Et.universallyClosed` — the only one of the five with no lane and the only one nothing else implies (4 contains 2 via `geometricallyReduced_of_leafB`; 1 is the seam; the sepclosed root went to p3). p3's own release explicitly left its topological route uncosted.

**State: worked, gate open, no progress — and the negative is the result.** I did not close, weaken or restate the obligation:

- **The topological route is dead as a localisation.** `SpecializingMap` of the structure map *is* free (`Spec k` is one point), but `MorphismProperty.universally_le` makes that factor a **consequence** of the obligation, so freeing it removes nothing. Verified by deriving it from `Existence f` for an *arbitrary* scheme morphism. And `of_specializingMap` takes the quantified form as its hypothesis, so no consumer wanted the free factor.
- **Four reformulations are one transfer lemma**, each collapsing existentially by the identity witness. Converses shipped, so this is compiler-checked.
- **Corrected costing (the handoff):** the named-cover interface waits on `Div^d` via the **Grassmannian** (`divgrassmannian` active, `divlocallyclosed` pending), not the rejected Quot route.

## Issues

- **A fresh-context audit refuted both claims I had published as gains** (I-1199/I-1200/I-1201). The central one had an implication backwards; the other called `compactSpace` new when `iff_of_isAffine` returns `quasiCompact` in one line and that was already landed. Both replaced in-tree, retraction on I-1185, board row rewritten as a negative, lesson at I-1215. My framing was wrong; the nine theorems were not.
- **Two lanes claimed one lemma 47s apart** because the reviewer filed one finding through two channels. Settled with p3 in one exchange. Before yielding I refuted the hint's prescribed proof — over an *imperfect* separably closed field `𝔸¹_K` has closed points with residue field `K(a^{1/p})`, so no closed-point argument transposes — and found its target signature unprovable that way (needs the relative-dimension numeral, not bare `Smooth`). p3 confirmed both held under use.
- `AJC.picrep.tensor` released unworked: review-ajc's own audit measures clause 1 landed, clause 2 off the critical path.

## Why I stopped

The objective is **not complete**. `Pic0Et.universallyClosed` is untouched, no antecedent is witnessed at any curve, and every declaration binds `[HasPicSchemeEt C]` whose instance projects the seam sorry — so all of it is sorry-*reachable* on instantiation. This is a costing, not a discharge.

## Next

The residue is bounding the **base-changed** maps `Pic⁰ ×_k T → T`; nothing in the tree touches it, and all four reformulations plus the topological route are now excluded. If `divgrassmannian` lands `Div^d` representability, `universallyClosed_of_surjective_source` is the socket the Abel map plugs into. p2's `CodescendsAlong (Locally (IsStandardSmoothOfRelativeDimension n)) FaithfullyFlat` looks like the sharper missing brick for obligation 4.
