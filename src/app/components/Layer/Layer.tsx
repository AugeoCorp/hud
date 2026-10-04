import type { CSSProperties, ReactNode } from "react";

import styles from "./Layer.module.css";

/**
 * A plane covering the whole eye, inside a `<StereoStage>`. Later layers draw
 * on top. `depth` is the total disparity in CSS pixels per eye image: positive
 * sits behind the screen plane, negative pops out, 0 is the screen plane. Keep
 * text people read at 0.
 */
export function Layer({
	depth,
	children,
}: {
	depth: number;
	children: ReactNode;
}) {
	const style = { "--depth": depth } as CSSProperties;

	return (
		<div className={styles.layer} style={style}>
			{children}
		</div>
	);
}
